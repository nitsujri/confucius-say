class OneOffs
  class StrokeImagesToWords

    #OneOffs::StrokeImagesToWords.go
    def self.go
      words = Word.where("char_length(chars_trad) = ?", 1)

      words.each_with_index do |word|
        stroke_image = File.join(Rails.root, "tmp", "stroke_images", word.chars_trad + "-bw.png")

        if File.exist?(stroke_image)
          ap ">>>> Found match: #{word.id}. #{word.chars_trad}"
          word.stroke_image = File.open(stroke_image)
          word.save
        end
        
      end
    end

  end
end