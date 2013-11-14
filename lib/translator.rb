class Translator

  class << self

    def load_translator
      yml_file = YAML.load_file(File.join(Rails.root, "config", 'google_translate.yml' ))
      api_key  = yml_file[Rails.env]["api_key"] if api_key.nil?

      @tot_retries  ||= ((yml_file[Rails.env]["retries"] if @tot_retries.nil?) || 0)

      ToLang.start(api_key)
    end

    def to_cht(string)
      check_env

      translate_with_retries 'en', 'zh-TW', string
    end

    def to_en(string)
      check_env
      
      translate_with_retries 'zh', 'en', string
    end

    def name
      "Google"
    end

    def url
      "http://translate.google.com"
    end

    private

    def translate_with_retries(from_lang, to_lang, to_translate)

      #try to find the translation
      translation = Translation.find_by(to_lang: to_lang, to_translate: to_translate)
      return translation.translated if translation.present?

      @translator ||= load_translator

      #This stupid thing was built because I hate bing and being in HK sets off stupid flags.
      tries = 0
      begin
        translated = to_translate.translate(to_lang)

        #record the translation
        Translation.create({
          :from_lang => from_lang,
          :to_lang => to_lang,
          :to_translate => to_translate,
          :translated => translated
        })

        translated
      rescue => e
        tries += 1
        retry if tries <= @tot_retries

        #If the retries don't work pass the exception upward
      end
    end

    def check_env
      raise "Not on Production. Not going to translate using Bing.com" unless Rails.env == "production"
    end
  end
end