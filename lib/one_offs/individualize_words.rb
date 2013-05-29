class OneOffs
  class IndividualizeWords

    def gather_single_chars
      check = []
      output = []
      collision_cnt = 0
      char_count = 0
      Word.all.each do |word|
        if word.chinese_trad.chars.count != word.chinese_simp.chars.count
          raise ">>>> We have something weird! Trad: #{word.chinese_trad}, Simp: #{word.chinese_simp}"
        end

        word.chinese_trad.chars.each_with_index do |c_trad, i|
          c_simp = word.chinese_simp[i]

          unless check.include? [c_trad, c_simp]

            #try to grab the jyutping or pinyin
            jyut = (word.jyutping.split(/\s/)[i] if word.jyutping.present?) || nil 
            piny = (word.pinyin.split(/\s/)[i] if word.pinyin.present?) || nil

            check << [c_trad, c_simp]
            output << {
              :chinese_trad => c_trad,
              :chinese_simp => c_simp,
              :jyutping     => jyut,
              :pinyin       => piny,
            }
            char_count += 1

          else
            collision_cnt += 1
          end

        end
      end

      ap ">>>> Individual Chars: #{char_count}; Collision Count: #{collision_cnt}"

      output
    end

    def stuff_into_db(chars)
      new_cnt = 0
      old_cnt = 0
      chars.each do |char|
        if word = Word.find_by(chinese_trad: char[:chinese_trad], chinese_simp: char[:chinese_simp])
          ap ">>>> Have #{word.chinese_trad}: #{word.id}"
          old_cnt += 1
        else
          #add & mark
          word = Word.create!({
            :chinese_trad => char[:chinese_trad],
            :chinese_simp => char[:chinese_simp],
            :jyutping     => char[:jyutping],
            :pinyin       => char[:pinyin],
            :single_char  => true
          })
          new_cnt += 1
          ap word
          ap ">>>> Created #{word.chinese_trad}: #{word.id}"
        end
      end

      ap ">>>> New Words Added: #{new_cnt}; Already Had: #{old_cnt}"
    end

    def run
      #gather all separate characters
      chars = gather_single_chars

      #perform search
      stuff_into_db(chars)

      ''
    end


    class << self
      def go
        OneOffs::IndividualizeWords.new.run     
      end
    end #self
  end
end