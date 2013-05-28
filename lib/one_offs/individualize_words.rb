class OneOffs
  class IndividualizeWords

    def gather_single_chars
      output = []
      collision_cnt = 0
      char_count = 0
      Word.all.limit(10000).each do |word|
        if word.chinese_trad.chars.count != word.chinese_simp.chars.count
          raise ">>>> We have something weird! Trad: #{word.chinese_trad}, Simp: #{word.chinese_simp}"
        end

        word.chinese_trad.chars.each_with_index do |c_trad, i|
          c_simp = word.chinese_simp[i]

          unless output.include? [c_trad, c_simp]
            output << [c_trad, c_simp]
          else
            collision_cnt += 1
          end

          char_count += 1
        end
      end

      ap ">>>> Collision Count: #{collision_cnt}/#{char_count}"

      output
    end

    def stuff_into_db(chars)
      chars.each do |char|
        if word = Word.find_by(chinese_trad: char[0], chinese_simp: char[1])
          ap ">>>> Have #{word.chinese_trad}: #{word.id}"
        else
          #add & mark
          word = Word.create!({
            :chinese_trad => char[0],
            :chinese_simp => char[1],
            :single_char => true
          })
          ap ">>>> Created #{word.chinese_trad}: #{word.id}"
        end
      end
    end

    def run
      #gather all separate characters
      chars = gather_single_chars

      #perform search
      # stuff_into_db(chars)

      ''
    end


    class << self
      def go
        OneOffs::IndividualizeWords.new.run     
      end
    end #self
  end
end