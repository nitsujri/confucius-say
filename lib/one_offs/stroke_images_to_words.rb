class OneOffs
  class StrokeImagesToWords

    #OneOffs::StrokeImagesToWords.go
    def self.go
      words = Word.where("char_length(chars_trad) = ?", 1)

      words.each_with_index do |word|
        
      end
    end

  end
end