class OneOffs
  class VerifyWords
    include HTTParty

    APPLICATION_NAME = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1468.0 Safari/537.36"

    def gather_words
      Words.where(:single_char => true)
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
          return response
        end
        
        #follow the redirect
        visit_site(word, redirect_url)

      else
        HTTParty.get(url)
      end
    end

    def parse_response(response)
      noko_html = Nokogiri::HTML(response.body)
      {
        :char           => noko_html.at_css('.word.script').text,
        :jyutping       => noko_html.at_css('.cardjyutping').text,
        :pinyin         => noko_html.at_css('.cardpinyin').text,
        :english        => noko_html.at_xpath('//*[@class="wordmeaning"]/text()').text.strip,
        :part_of_speech => noko_html.at_xpath('//*[@class="posicon"]/@title').text,
      }
    end

    def store_extracted(word, from_site)
      word.set_data("canto_dict", from_site)
    end

    def run
      #gather words
      # words = gather_words
      word = Word.find(5787)

      #visit translator
      response = visit_site(word.chinese_trad)

      #extract response
      extracted_word = parse_response(response)

      #verify and store
      store_extracted(word, extracted_word)

    end

    class << self
      def go
        OneOffs::VerifyWords.new.run
      end
    end
  end
end