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

        parsed_html  = Nokogiri::HTML(HTTParty.post(url, :headers => {"User-Agent" => APPLICATION_NAME}, :body => payload))
        redirect     = parsed_html.at_css('meta[http-equiv="refresh"]')
        redirect_url = redirect.attributes["content"].value.gsub(/1;url=/, "")
        
        visit_site(word, redirect_url)
      else
        HTTParty.get(url)
      end
    end

    def run
      #gather words
      # words = gather_words

      word = Word.find(5787).chinese_trad
      #visit translator
      response = visit_site(word)

      ap response
      #extract response

      #verify and store
    end

    class << self
      def go
        OneOffs::VerifyWords.new.run
      end
    end
  end
end