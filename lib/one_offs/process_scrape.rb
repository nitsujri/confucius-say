class OneOffs
  class ProcessScrape
    START_LINE = 0

    def process
      data = gather_data

      data.drop(START_LINE).each_with_index do |d, i|
        d = d[:canto_dict]
        extract_compounds(d)
        extract_examples(d)

        break
      end
    end

    def gather_data
      ExtraData.all
    end

    def extract_compounds(data)
      data = data[:compounds]
    end

    def extract_examples(data)
      
    end

    class << self
      def go
        OneOffs::ProcessScrape.new.process
      end
    end
  end
end
