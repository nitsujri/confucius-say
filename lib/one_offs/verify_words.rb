class OneOffs
  class VerifyWords
    include HTTParty

    STARTING_AT = 0


    APPLICATION_NAME = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1468.0 Safari/537.36"

    def gather_words
      Word.where("char_length(chars_trad) = ?", 1)
    end

    def visit_site(word, url = nil, limit = 5)
      unless url.present?
        url = "http://www.cantonese.sheik.co.uk/scripts/wordsearch.php?level=0"
        payload = {
          "SEARCHTYPE"      => 2,
          "TEXT"            => word,
          "radicaldropdown" => 0,
          "searchsubmit"    => "search"
        }

        response    = HTTParty.post(url, :headers => {"User-Agent" => APPLICATION_NAME}, :body => payload)
        parsed_html = Nokogiri::HTML(response)
        redirect    = parsed_html.at_css('meta[http-equiv="refresh"]')

        if redirect.present?
          redirect_url = redirect.attributes["content"].value.gsub(/1;url=/, "")
        else
          #There was no redirect, not dealing with that page
          return false
        end
        
        ap ">>>> Following Redirect: #{redirect_url}"

        #follow the redirect
        visit_site(word, redirect_url)

      else
        HTTParty.get(url)
      end
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
        chars_trad = [{:type => "mainchar", :char_trad => compound.at_css(".mainchar").text}]
        compound.css(".linkchar").each{ |c| 
          chars_trad << { :type => "linkedchar", :char_trad => c.text, :full_detail_url => c[:href] }
        }

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
        noko_example = noko_example.children

        fd_url = noko_example.at_css("a")[:href]

        #because they don't have clear markers, ugh
        sound_url = noko_example.css("a")[1][:href] if noko_example.css("a")[1].css("img").present?

        chars_trad = noko_example.css(".wordexample a").map do |a|
          {:chars_trad => a.text, :full_detail_url => a[:href]}
        end

        #grab if cantonese or mandarin only based on css
        usage = if noko_example.at_css(".cantonesebox").present?
          "cantonese"
        elsif noko_example.at_css(".mandrinbox").present?
          "mandrin"
        end

        examples << {
          :full_detail_url   => fd_url,
          :sound_example_url => sound_url,
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
        :compounds      => compounds,
        :examples       => examples,
      }
    end

    def store_extracted(word, data)
      word.set_data("canto_dict", data)
      word.jyutping = data[:jyutping] #get what we originally came for, lol
      word.save!
    end

    def run
      #gather words
      words = gather_words

      words.drop(STARTING_AT).each_with_index do |word, index|
        ap ">>>> #{index+1}. Going After: #{word.id}"

        #visit translator
        response = visit_site(word.chars_trad)

        next unless response

        #extract response
        extracted_data = parse_response(response)

        #verify and store
        store_extracted(word, extracted_data)

      end

      ''

    end

    class << self
      def go
        #OneOffs::VerifyWords.go
        OneOffs::VerifyWords.new.run
      end
    end
  end
end