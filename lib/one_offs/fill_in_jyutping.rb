class OneOffs
  class FillInJyutping < Base

    Word.where(jyutping: nil).each_with_index do |word, index|
      ap ">>> #{index}. Processing #{word.id}"

      chars = word.chars_trad.present? ? word.chars_trad : word.chars_simp

      jyutping = []
      pinyin = []
      chars.split("").each do |char|

        found_word = Word.where("chars_trad = ? OR chars_simp = ?", char, char).first

        next unless found_word.present?

        jyutping << found_word.jyutping
        pinyin << found_word.pinyin

      end

      word.jyutping = jyutping.join(" ")
      word.pinyin = pinyin.join(" ")

      begin
        word.save
      rescue => e
        ap e.message
      end

    end

  end
end
