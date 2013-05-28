class WordLoader
  class LoaderPinyin < WordLoaderBase
    TESTING_DEPTH = 0 #set to 0 for not testing!
    START_LINE = 0

    def run(filename = "cedict_1_0_ts_utf-8_mdbg.txt")
      read_file(filename).drop(START_LINE).each_with_index do |line, index|

        split   = line.split(/\//, 2)
        chinese = split[0].strip if split[0]
        english = split[1].gsub(/\/\r\n/, "") if split[1]

        #must remove jyut []
        split_py = chinese.match(/\[(.*)\]/)
        piny     = split_py[1] || nil

        split_ch = chinese.split(/\s/)
        trad     = split_ch[0] || nil
        simp     = split_ch[1] || nil

        begin
          #find the word
          #if found, add pinyin and english

          if word = Word.find_by_chinese_trad_and_chinese_simp(trad, simp)
            #We're checking if we've added this already
            if word.english.present?
              
              unless word.english == english
                word.english_2 = english #if we have a second definition, reconile later
                  
                ap ">>>> Old Word - Stashing New Def: #{START_LINE + index} Word: #{word.id}"
              else
                ap ">>>> Already There: #{START_LINE + index} Word: #{word.id}"
              end
            else
              word.english = english #if we have a second definition, reconile later

              ap ">>>> Old Word - New Definition: #{START_LINE + index} Word: #{word.id}"
            end

            word.pinyin = piny
            word.save!
          else
            word = Word.create!({
              :chinese_trad => trad,
              :chinese_simp => simp,
              :pinyin => piny,
              :english => english
            })
            ap ">>>> Created: #{START_LINE + index}"
          end

        rescue => e
          ap ">>>> Skipped: #{START_LINE + index}"
        end

      end
    end

    class << self
      def go
        WordLoader::LoaderPinyin.new.run
      end
    end
  end
end