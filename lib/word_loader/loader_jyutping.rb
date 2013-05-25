class WordLoader
  class LoaderJyutping


    def run
      "HIHI"
    end

    class << self
      def go
        WordLoader::LoaderJyutping.new.run
      end
    end
  end
end