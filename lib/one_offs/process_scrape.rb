class OneOffs
  class ProcessScrape
    START_LINE = 0

    def process
      data = gather_data

      data.drop(START_LINE).each_with_index do |d, i|
        scrape_data = d.data[:canto_dict]

        extract_char_data(d)
        # extract_compounds(scrape_data)
        
        break
      end

      # process_examples
    end

    def process_examples
      #We want to go over them separately AFTER we've run through all the compounds so it is easier to link.
      data.each_with_index do |d, i|
        extract_examples(scrape_data)
      end
    end

    def gather_data
      ExtraData.all
    end

    def extract_char_data(full_data)
      orig_word   = full_data.storable
      scrape_data = full_data.data[:canto_dict]

      unless orig_word.more_info.present?
        orig_word.build_more_info(
          part_of_speech: scrape_data[:part_of_speech],
          stroke_count: scrape_data[:stroke_count].match(/[0-9].*/).to_s,
          radical: scrape_data[:radical].strip,
          level: scrape_data[:level],
        ).save
      end

    end

    def extract_compounds(data)
      compounds_data = data[:compounds]
      compounds      = compounds_data[:the_compounds]

      #rebuild compound
      compounds.each do |compound_data|

        word = insert_compound(compound_data)
        
        #should link words based upon the the_compounds
        link_compound_subwords(word, compound_data)

      end

    end

    def insert_compound(compound_data)
      chars_trad = []
      chars_simp = []
      pinyin = []

      compound_data[:chars_trad].each do |char_data|
        root_char = Word.find_by(chars_trad: char_data[:char_trad])

        chars_trad << root_char.chars_trad
        chars_simp << root_char.chars_simp
        pinyin << root_char.pinyin
      end

      #load data
      word = Word.where(
        chars_trad: chars_trad.join,
        chars_simp: chars_simp.join,
      ).first_or_create

      word.update_attributes({ 
        :jyutping   => compound_data[:jyutping],
        :pinyin     => pinyin.join(" "),
        :english    => compound_data[:english] 
      })

      WordData.where(
        :word_id => word.id,
        :usage   => compound_data[:usage]
      ).first_or_create

      word
    end

    def extract_examples(data)
      
    end

    def link_compound_subwords(word, compound_data)
      #find individual chars, create link from compound => subword
      compound_data[:chars_trad].each do |char_data|
        subword = Word.find_by(chars_trad: char_data[:char_trad])
        word.subword_word_links.create(word_id: subword.id)
      end
    end

    class << self
      def go
        #OneOffs::ProcessScrape.go
        OneOffs::ProcessScrape.new.process
      end
    end #self
  end#process scrape
end
