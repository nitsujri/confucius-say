class OneOffs
  class ProcessScrape
    START_LINE = 0

    def process
      data = gather_data

      data.drop(START_LINE).each_with_index do |d, i|
        d = d.data[:canto_dict]

        extract_compounds(d)
        extract_examples(d)

        break
      end
    end

    def gather_data
      ExtraData.all
    end

    def extract_compounds(data)
      compounds_data = data[:compounds]
      compounds      = compounds_data[:the_compounds]

      #rebuild compound
      compounds.each do |compound_data|
        ap compound_data
        compound = compound_data[:chars_trad].map do |char_data|
          char_data[:char_trad]
        end.join()

        #search for compound
        if word = Word.find_by_chars_trad(compound)
          #if found, update
        else
          #if not found, create

        end
        
        
        #find individual chars, create link from compound => individual word
        # word.compound_word_link.create()
      end
      



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
