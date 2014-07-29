#WHY DID YOU WRITE THIS SO STUPIDLY!?

class OneOffs
  class CrawlWords < Base
    include HTTParty

    def go_crawl(single_num)

      if(single_num)
        response = visit_char(single_num)
        extracted_data = parse_response(response)

        ap extracted_data
        return ''
      end

      (1..10000).drop(start_position_for(self.class.to_s)).each do |pass_index|

        response = visit_char(pass_index)

        if response
          #extract response
          extracted_data = parse_response(response)

          # ap extracted_data

          unless extracted_data.empty?
            #verify and store
            store_extracted(pass_index, extracted_data)

            #from base
            increment_start_pos(self.class.to_s)
          end
        end

        # break # For testing
      end

      ''

    end

    def visit_char(pass_index)

      url = "http://www.cantonese.sheik.co.uk/dictionary/characters/#{pass_index}/?all=true&full=true"

      ap ">>>> #{pass_index}. Going After: #{url}"

      attempts = 0
      begin
        response    = HTTParty.get(url, :headers => {"User-Agent" => OneOffs::APPLICATION_NAME})
      rescue => e
        ap ">>>> #{e.message}"
        attempts += 1
        retry if attempts <= 5
      end

      response.body.match("Sorry, I couldn't find a character"){ |m|
        return false
      }

      response

    end

    def parse_response(response)

      ap ">>>> Parsing"

      noko_html = Nokogiri::HTML(response.body)

      the_compounds  = []
      compounds_info = nil

      #Way easier to split using raw than noko
      noko_html.css(".cantodictbg1.white").children.to_s.split(/<br>/).each do |text|
        compound = Nokogiri::HTML(text)

        next unless compound.at_css("a").present? #not very robust, but if we don't have any links, assume we should skip

        #get urls
        fd_url = compound.at_css("a")[:href]

        #there's a full list dictionary url at the end. annoying to retrieve.
        if fd_url.include? "/dictionary/characters/"
          compounds_info = {
            :full_compounds_list_url => fd_url
          }
          next #that's all we want!
        end

        #grab the chinese chars
        #redo inside chinesemed
        chars_trad = []
        compound.at_css(".chinesemed").children.each do |word|

          if word[:class] == "mainchar"
            chars_trad << { :type => word[:class], :char_trad => word.text }
          else
            chars_trad << { :type => word[:class], :char_trad => word.text, :full_detail_url => word[:href] }
          end
        end

        #pronounciation baby!!
        jyutping = compound.at_css(".summary_jyutping").try(:text)
        pinyin   = compound.at_css(".summary_pinyin").try(:text)

        #english
        english = compound.xpath("//body/child::text()").text.split(/\=/)[1].strip if compound.xpath("//body/child::text()").text.split(/\=/)[1].present?

        #grab if cantonese or mandarin only based on css
        usage = if compound.at_css(".cantonesebox").present?
          "cantonese"
        elsif compound.at_css(".mandrinbox").present?
          "mandrin"
        end

        the_compounds << {
          :full_detail_url => fd_url,
          :chars_trad => chars_trad,
          :jyutping   => jyutping,
          :pinyin     => pinyin,
          :english    => english,
          :usage      => usage,
        }
      end

      compounds = {
        :info => compounds_info,
        :the_compounds => the_compounds,
      }

      examples = []

      #Let's go fetch full sentence examples
      noko_html.css(".example_in_block").each do |noko_example|

        fd_url = noko_example.children.at_css("a")[:href]

        #because they don't have clear markers, ugh
        sound_url = noko_example.children.css("a")[1][:href] if noko_example.children.css("a")[1].css("img").present?

        chars_trad = noko_example.children.css(".wordexample a").map do |a|
          {:chars_trad => a.text, :full_detail_url => a[:href]}
        end

        #grab if cantonese or mandarin only based on css
        usage = if noko_example.children.at_css(".cantonesebox").present?
          "cantonese"
        elsif noko_example.children.at_css(".mandrinbox").present?
          "mandrin"
        end

        english_meaning = noko_example.at_css(".wordexamplemeaning").text

        examples << {
          :full_detail_url   => fd_url,
          :sound_example_url => sound_url,
          :english           => english_meaning, #forgot ot add this
          :chars_trad        => chars_trad,
          :useage            => usage
        }
      end

      #full return
      {
        :char           => noko_html.at_css('.word.script').try(:text),
        :jyutping       => noko_html.at_css('.cardjyutping').try(:text),
        :pinyin         => noko_html.at_css('.cardpinyin').try(:text),
        :english        => noko_html.at_xpath('//*[@class="wordmeaning"]/text()').try(:text).try(:strip),
        :part_of_speech => noko_html.at_xpath('//*[@class="posicon"]/@title').try(:text),
        :stroke_count   => noko_html.at_css('.charstrokecount').try(:text),
        :radical        => noko_html.at_css('.charradical').try(:text),
        :level          => noko_html.at_css('.charlevel').try(:text),
        :url            => response.request.last_uri.to_s,
        :compounds      => compounds,
        :examples       => examples,
      }
    end

    def store_extracted(index, data)
      ed = ExtraData.where(
        storable_id: index,
        storable_type: 'WordCrawl',
      ).first_or_create

      ed.update_attributes!(data: data)
    end

    class << self
      def go(num = nil)
        #OneOffs::VerifyWords.go
        OneOffs::CrawlWords.new.go_crawl(num)
      end
    end
  end
end
