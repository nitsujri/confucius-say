class OneOffs
  class CrawlExamples < Base

    def visit_url(num)
      base_url = "http://www.cantonese.sheik.co.uk/dictionary/examples/"
      url      = base_url + "/#{num}/"

      response = HTTParty.get(url)

      return false if response.body.match(/Sorry, I couldn't find a sentence example with an ID/).present?

      response.body
    end

    def parse(data)
      noko_data = Nokogiri::HTML(data.body)
    end

    def run
      (start_position_for(self.class.to_s)..1600).each_with_index do |e_num, index|
        ap ">>>> #{index+1}. Going After: #{e_num}"
        data = visit_url(e_num)

        unless data
          ap ">>>> #{index+1}. Returned No Data"
          increment_start_pos(self.class.to_s)
          next
        end

        parse(data)

        break

        #from base
        increment_start_pos(self.class.to_s)
      end
    end

    class << self
      def go
        #OneOffs::CrawlExamples.go
        OneOffs::CrawlExamples.new.run
      end
    end

  end
end