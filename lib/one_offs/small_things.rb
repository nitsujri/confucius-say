class OneOffs
  class SmallThings

    class << self
      def combine_multiple_pronouncations
        words = Word.where("CHAR_LENGTH(chars_trad) = ?", 1).limit(1000)
        words.each do |word|

          if word.pinyin.present? && word.pinyin.split(" ").count > 1
            word.update_column(:pinyin, word.pinyin.gsub(/\s/, "/"))
          end

          if word.jyutping.present? && word.jyutping.split(" ").count > 1
            word.update_column(:jyutping, word.jyutping.gsub(/\s/, "/"))
          end

        end
        ''
      end

    end #self

  end
end