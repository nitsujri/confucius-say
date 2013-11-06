class Translator

  class << self

    def load_bing_translator
      yml_file = YAML.load_file(File.join(Rails.root, "config", 'bing_translator.yml' ))

      client_id     = yml_file[Rails.env]["client_id"] if client_id.nil?
      client_secret = yml_file[Rails.env]["client_secret"] if client_secret.nil?
      @tot_retries  ||= ((yml_file[Rails.env]["retries"] if @tot_retries.nil?) || 10)

      BingTranslator.new(client_id, client_secret)
    end

    def to_cht(string)
      check_env

      translate_with_retries 'en', 'zh-CHT', string
    end

    def to_en(string)
      check_env
      
      translate_with_retries 'zh', 'en', string
    end

    private

    def translate_with_retries(from_lang, to_lang, to_translate)

      #try to find the translation
      translation = Translation.find_by(to_lang: to_lang, to_translate: to_translate)
      return translation.translated if translation.present?

      @translator ||= load_bing_translator

      #This stupid thing was built because I hate bing and being in HK sets off stupid flags.
      bing_tries = 0
      begin
        translated = @translator.translate to_translate, :to => to_lang

        #record the translation
        Translation.create({
          :from_lang => from_lang,
          :to_lang => to_lang,
          :to_translate => to_translate,
          :translated => translated
        })

        translated
      rescue BingTranslator::Exception => e
        bing_tries += 1
        retry if bing_tries <= @tot_retries

        #If the retries don't work pass the exception upward
        raise BingTranslator::Exception.new e
      end
    end

    def check_env
      raise BingTranslator::Exception.new "Not on Production. Not going to translate using Bing.com" unless Rails.env == "production"
    end
  end
end