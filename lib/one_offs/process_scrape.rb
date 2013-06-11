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

        chars_trad = compound_data[:chars_trad].map do |char_data|
          char_data[:char_trad]
        end.join

        chars_simp = []
        pinyin = []
        compound_data[:chars_trad].each do |char_data|
          root_char = Word.find_by(chars_trad: char_data[:char_trad])
          chars_simp << root_char.chars_simp
          pinyin << root_char.pinyin
        end

        #load data
        word = Word.where(
          :chars_trad => chars_trad,
          :chars_simp => chars_simp.join,
          :jyutping   => compound_data[:jyutping],
          :pinyin     => pinyin.join(" "),
          :english    => compound_data[:english],
        ).first_or_create

        WordData.where(
          :word_id => word.id,
          :usage   => compound_data[:usage]
        ).first_or_create
        

        link_compound_subwords(word)

      end

    end

    def extract_examples(data)
      
    end

    def link_compound_subword(word)
      #find individual chars, create link from compound => subword
      word.chars_trad.split.each do |char_trad|
        subword = Word.find_by(chars_trad: char_trad)
        word.compound_word_links.create(word_id: subword.id)
      end
    end

    class << self
      def go
        #OneOffs::ProcessScrape.go
        OneOffs::ProcessScrape.new.process
      end
    end
  end
end
