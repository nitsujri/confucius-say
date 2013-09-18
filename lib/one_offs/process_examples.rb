class OneOffs
  class ProcessExamples < Base

    def load
      load_examples
    end

    def load_examples

      ExtraData.where({:storable_type => "Word"}).drop(start_position_for(self.class.to_s)).each_with_index do |ed, index|
        ap ">>>> #{index}. Working: #{ed.id}"
        ed.data[:canto_dict][:examples].each do |example|
          #create the word
          combined_chars = example[:chars_trad].map{|v| v[:chars_trad]}

          begin
            word = Word.where(chars_trad: combined_chars.join).first_or_create
          rescue => e
            ap "!!!!! ERROR: #{e.message}, skipping"
            next
          end

          CompoundWordLink.where(word_id: ed.storable_id, compound_id: word.id).first_or_create

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
          word.english    = example[:english]
          word.jyutping   = combined_jyutping.strip unless combined_jyutping.empty? or !combined_jyutping_check
          word.pinyin     = combined_pinyin.strip unless combined_pinyin.empty? or !combined_pinyin_check

          word.save

          #create the extra data
          if word.more_info.present?
            word.more_info.update_column(:sound_url, example[:sound_example_url])
          else
            word.create_more_info(sound_url: example[:sound_example_url])
          end

          ap ">>>> Created Word: #{word.id}. #{word.chars_trad}"

        end

        increment_start_pos(self.class.to_s)

      end
    end

    class << self
      def go
        #OneOffs::ProcessExamples.go
        OneOffs::ProcessExamples.new.load
      end
    end
  end
end