class OneOffs
  class RemovePos < Base

    def load_words
      to_rm = ["%Additional PoS%", "%Stroke count%", "%Default PoS%"]
      Word.where("english LIKE ? OR english LIKE ? OR english LIKE ?", to_rm[0], to_rm[1], to_rm[2])
    end

    def remove_pos(word)
      new_english = word.english.gsub(/(\[www.cantonese.sheik.co.uk\]|\sSee this link|\n|Additional PoS|Stroke count|Default PoS).*/im, "").try(:strip)

      ap new_english
      word.update_attributes!({
        english: new_english
      })
    end

    #OneOffs::RemovePos.new.go
    def go
      load_words.each do |word|
        remove_pos(word)
      end
      ''
    end


  end
end
