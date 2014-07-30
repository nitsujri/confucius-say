class OneOffs
  class RecrawlEmptyEnglish < Base

    def load_words
      Word.where("english = ? OR !(english > '') AND CHAR_LENGTH(chars_trad) = 1", "[")
    end

    def find_in_datas(bad_word)
      @eds ||= ExtraData.where(storable_type: "WordCrawl")

      match = @eds.find do |ed|
        bad_word.chars_trad == ed.data[:char]
      end

      return nil if match.blank?

      match.data.with_indifferent_access[:url]
    end

    def visit_url(url)
      HTTParty.get(url)
    end

    def parse_english(response)
      noko = Nokogiri::HTML(response)

      text = noko.at_css(".wordmeaning").text.strip.gsub(/(\[www.cantonese.sheik.co.uk\]|\sSee this link|Additional PoS|Stroke count|Default PoS).*/im, "")

      text_arr = text.split(/(\r\n|\n)/).map{ |x| x.strip }.reject!(&:blank?)
      unless text_arr.blank?
        text_arr.join("<br>")
      else
        text
      end
    end

    def process(word)
      ap ">>>> Working on: #{word.chars_trad}"

      url = find_in_datas(word)

      ap ">>>> No URL!" && return if url.blank?

      ap ">>>> Visiting: #{url}"
      response = visit_url(url)

      meaning = parse_english(response)
      ap ">>>> #{meaning}"

      retries = 0
      begin
        word.update_attributes({
          english: meaning
        })
      rescue => e
        e.message.match(/:\s'(.*?)[\s'\)]/im){ |m|
          match = m[1].gsub("\\", '\\')
          meaning.gsub!(/#{m[1]}/,"")
        }

        retries += 1
        ap "!!!! Retrying"
        retry if retries < 5
        raise e
      end

    end

    #reload!; OneOffs::RecrawlEmptyEnglish.new.go
    def go

      load_words.each{ |word| process(word) }

    end

  end
end
