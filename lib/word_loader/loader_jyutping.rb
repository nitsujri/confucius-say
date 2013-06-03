class WordLoader
  class LoaderJyutping < WordLoaderBase
    TESTING_DEPTH = 0
    START_LINE = 100996

    def run
      read_file.drop(START_LINE).each_with_index do |line, index|

        split   = line.split(/\//, 2)
        chinese = split[0].strip if split[0]
        english = split[1].gsub(/\/\r\n/, "") if split[1]

        #must remove jyut []
        split_jy = chinese.match(/\[(.*)\]/)
        jyut     = split_jy[1] || nil

        split_ch = chinese.split(/\s/)
        trad     = split_ch[0] || nil
        simp     = split_ch[1] || nil

        begin
          Word.where({
            :chars_trad => trad, 
            :chars_simp => simp, 
            :jyutping => jyut, 
            :english => english
          }).first_or_create

          ap ">>>> Finished: #{START_LINE + index}"
        rescue => e
          ap ">>>> Skipped: #{START_LINE + index}"
        end
      end
      "HIHI"
    end

    class << self
      def go
        WordLoader::LoaderJyutping.new.run
      end
    end
  end
end