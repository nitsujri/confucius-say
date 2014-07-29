class OneOffs
  class ProcessWordsCrawl < Base


    def process
      data = ExtraData.where(storable_type: "WordCrawl")

      data.drop(start_position_for(self.class.to_s)).each_with_index do |d, i|
        scrape_data = d.data.with_indifferent_access

        build_word(scrape_data)
        extract_compounds(scrape_data)

        extract_examples(scrape_data)

        increment_start_pos(self.class.to_s)

        # break # For testing
      end


    end

    ############### Extraction Handling ###############

    def build_word(data)

      orig_word = Word.where(
        chars_trad: data["char"]
      ).first_or_create

      orig_word.update_attributes!({
          jyutping: data["jyutping"],
          pinyin: data["pinyin"],
          english: data["english"],

      })

      unless orig_word.more_info.present?
        orig_word.build_more_info(
          part_of_speech: data[:part_of_speech],
          stroke_count: data[:stroke_count].match(/[0-9].*/).to_s,
          radical: data[:radical].strip,
          level: data[:level],
        ).save
      end
    end

    def extract_compounds(data)
      compounds_data = data[:compounds]
      compounds      = compounds_data[:the_compounds]

      #rebuild compound
      compounds.each do |compound_data|

        word = insert_compound(compound_data)

        #Link the subwords based on their compounds
        link_compound_subwords(word, compound_data) if word

      end

    end

    def extract_examples(data)
      examples_data = data[:examples]

      examples_data.each do |example_data|
        insert_example(example_data)
      end

    end

    ################ Main Insert Functions ###############

    def insert_compound(compound_data)
      chars_trad = []
      chars_simp = []
      pinyin = []

      compound_data[:chars_trad].each do |char_data|
        begin
          root_char = Word.where(chars_trad: char_data[:char_trad]).first_or_create
        rescue ActiveRecord::StatementInvalid => e
          ap e.message
          return false
        end

        chars_trad << root_char.chars_trad
        chars_simp << root_char.chars_simp
        pinyin << root_char.pinyin
      end

      #load data
      word = Word.where(
        chars_trad: chars_trad.join,
        # chars_simp: chars_simp.join,
      ).first_or_create!

      word.update_attributes({
        :jyutping   => compound_data[:jyutping],
        :pinyin     => pinyin.join(" "),
        :english    => compound_data[:english]
      })

      WordData.where(
        :word_id => word.id,
        :usage   => compound_data[:usage]
      ).first_or_create

      ap ">>>> Compound Inserted: #{word.chars_trad}"

      word
    end

    def link_compound_subwords(word, compound_data)
      #find individual chars, create link from compound => subword
      compound_data[:chars_trad].each do |char_data|
        subword = Word.find_by(chars_trad: char_data[:char_trad])
        word.subword_word_links.create(word_id: subword.id)
      end
    end

    def insert_example(example_data)

      #create the word
      combined_chars = example_data[:chars_trad].map{|v| v[:chars_trad]}

      begin
        word = Word.where(chars_trad: combined_chars.join).first_or_create
      rescue => e
        ap "!!!!! ERROR: #{e.message}, skipping"
        return
      end

      #check to see if we're missing any char sets from being added
      # There HAS to be a better way to do this
      combined_simp           = ""
      combined_simp_check     = true
      combined_jyutping       = ""
      combined_jyutping_check = true
      combined_pinyin         = ""
      combined_pinyin_check   = true
      combined_chars.each do |chars|
        #add them in, we'll deal with them later
        small_word = Word.where({:chars_trad => chars}).first_or_create

        #link the words
        CompoundWordLink.where(word_id: small_word.id, compound_id: word.id).first_or_create

        #find a way to make that one thing disappear if we don't have it

        #find chars simplified
        if small_word.chars_simp.present?
          combined_simp += small_word.chars_simp
        else
          combined_simp_check = false
        end

        if small_word.jyutping.present?
          combined_jyutping += small_word.jyutping + " "
        else
          combined_jyutping_check = false
        end

        if small_word.pinyin.present?
          combined_pinyin   += small_word.pinyin + " "
        else
          combined_pinyin_check = false
        end

      end

      #load parts
      word.chars_simp = combined_simp unless combined_simp.empty? or !combined_simp_check
      word.english    = example_data[:english]
      word.jyutping   = combined_jyutping.strip unless combined_jyutping.empty? or !combined_jyutping_check
      word.pinyin     = combined_pinyin.strip unless combined_pinyin.empty? or !combined_pinyin_check

      word.save

      #create the extra data
      if word.more_info.present?
        word.more_info.update_column(:sound_url, example_data[:sound_example_url])
      else
        word.create_more_info(sound_url: example_data[:sound_example_url])
      end

      ap ">>>> Created Example: #{word.id}. #{word.chars_trad}"

    end


    class << self
      def go
        #OneOffs::ProcessWordsCrawl.go
        ActiveRecord::Base.logger.level = 1 # Surpresses the crazy SQL output we see here

        OneOffs::ProcessWordsCrawl.new.process
      end
    end #self
  end#process scrape
end
