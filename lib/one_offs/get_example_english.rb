class OneOffs
  class GetExampleEnglish < Base
    #I forgot to get the english translations for all the examples. We gotta go get it and stuff it back in.

    def fetch_english_meaning
      #try to get the start position
      #from base

      ExtraData.all.drop(start_position_for(self.class.to_s)).each_with_index do |ed, index|
        #find ones with examples
        data = ed.data

        ap ">>>> #{index}. Processing #{ed.id}"

        next unless data[:canto_dict].present?

        #visit full detail url
        data[:canto_dict][:examples].each_with_index do |example, i|
          url = example[:full_detail_url]
          #visit url

          if data[:canto_dict][:examples][i][:english].present?
            ap ">>>> Been Here! #{url}"
            next
          end

          ap ">>>> Visiting URL: #{url}"

          response  = HTTParty.post(url, :headers => {"User-Agent" => OneOffs::APPLICATION_NAME})
          noko_html = Nokogiri::HTML(response)

          #extract english
          english = noko_html.at_xpath('//*[@class="audioplayer"]/text()').try(:text).try(:strip)

          next if english.blank? #skip this is if we have no result

          #stuff back into data
          data[:canto_dict][:examples][i][:english] = english
        end

        #save data if it changed
        ed.update_attribute(:data, data)

        #from base
        increment_start_pos(self.class.to_s)
        
      end #end extra data
    end

    class << self
      def go
        #OneOffs::GetExampleEnglish.go
        OneOffs::GetExampleEnglish.new.fetch_english_meaning
      end
    end
  end
end
