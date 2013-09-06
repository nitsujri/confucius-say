class OneOffs
  class ProcessExamples < Base

    def load
      load_examples
    end

    def load_examples

      ExtraData.where({:storable_type => "Word"}).drop(start_position_for("load_examples")).each_with_index do |ed, index|
        ed.data[:canto_dict][:examples].each do |example|
          #create the word
          combined_chars = example[:chars_trad].map{|v| v[:chars_trad]}

          #check to see if we're missing any char sets from being added
          combined_simp     = ""
          combined_jyutping = ""
          combined_pinyin   = ""
          combined_chars.each do |chars|
            #add them in, we'll deal with them later
            small_word = Word.where({:chars_trad => chars}).first_or_create

            #find chars simplified
            combined_simp += small_word.chars_simp
            combined_jyutping += small_word.jyutping + " "
            combined_pinyin   += small_word.pinyin + " "

          end
          
          word = Word.where({:chars_trad => combined_chars.join}).first_or_create

          #load parts
          word.english    = example[:english]
          word.chars_simp = combined_simp unless combined_simp.empty?
          word.jyutping   = combined_jyutping.strip unless combined_jyutping.empty?  
          word.pinyin     = combined_pinyin.strip unless combined_pinyin.empty?

          word.save

          break
          #link the word parts
          #create the extra data

        end

        increment_start_pos("load_examples")
        break
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