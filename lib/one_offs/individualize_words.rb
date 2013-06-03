class OneOffs
  class IndividualizeWords

    def gather_single_chars

      ap ">>>> Grabbing all words and singling out characters"

      check = []
      output = []
      collision_cnt = 0
      char_count = 0
      batch_cnt = 0
      Word.all.find_in_batches(:batch_size => 1000) do |batch|
        
        ap ">>>> Working on #{batch_cnt * 1000}-#{(batch_cnt + 1) * 1000}"
        batch_cnt += 1

        batch.each do |word|

          if word.chars_trad.chars.count != word.chars_simp.chars.count
            raise ">>>> We have something weird! Trad: #{word.chars_trad}, Simp: #{word.chars_simp}"
          end

          word.chars_trad.chars.each_with_index do |c_trad, i|
            c_simp = word.chars_simp[i]

            unless check.include? [c_trad, c_simp]

              #try to grab the jyutping or pinyin
              jyut = (word.jyutping.split(/\s/)[i] if word.jyutping.present?) || nil 
              piny = (word.pinyin.split(/\s/)[i] if word.pinyin.present?) || nil

              check << [c_trad, c_simp]
              output << {
                :chars_trad => c_trad,
                :chars_simp => c_simp,
                :jyutping     => jyut,
                :pinyin       => piny,
              }
              char_count += 1

            else
              collision_cnt += 1
            end

          end 
        end #batch
      end #find_in_batches

      ap ">>>> Individual Chars: #{char_count}; Collision Count: #{collision_cnt}"

      output
    end

    def stuff_into_db(chars)
      new_cnt = 0
      old_cnt = 0
      chars.each do |char|
        if word = Word.find_by(chars_trad: char[:chars_trad], chars_simp: char[:chars_simp])
          ap ">>>> Have #{word.chars_trad}: #{word.id}"
          old_cnt += 1
        else
          begin
            #add & mark
            word = Word.create!({
              :chars_trad => char[:chars_trad],
              :chars_simp => char[:chars_simp],
              :jyutping     => char[:jyutping],
              :pinyin       => char[:pinyin],
              :single_char  => true
            })
            new_cnt += 1
            ap ">>>> Created #{word.chars_trad}: #{word.id}"
          rescue => e
            ap ">>>> EPIC FAIL: #{char[:chars_trad]} #{char[:chars_simp]}; #{e.message} "
          end
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