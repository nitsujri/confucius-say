class OneOffs
  class LinkWords

    def single_words
      Word.where("char_length(chars_trad) = ?", 1)
    end

    def link_words
      #find
      single_words.find_in_batches(:batch_size => 1000) do |batch|
        batch.each do |word|
          #Get all the phrases that contain this word, except itself
          match_ids = Word.where('(chars_trad LIKE ? OR chars_simp LIKE ?) AND id <> ?', "%#{word.chars_trad}%", "%#{word.chars_trad}%", word.id).map(&:id)
        end #batch
      end #batches
      
    end

    class << self
      def go
        OneOffs::LinkWords.new.link_words
      end
    end
  end
end