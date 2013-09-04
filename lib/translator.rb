class Translator

  def load_bing_translator
    yml_file = YAML.load_file(File.join(Rails.root, "config", 'bing_translator.yml' ))

    client_id     = yml_file["development"]["client_id"] if client_id.nil?
    client_secret = yml_file["development"]["client_secret"] if client_secret.nil?

    BingTranslator.new(client_id, client_secret)
  end

  class << self
    def load
      @translator ||= Translator.new.load_bing_translator
    end

    def to_cht(string)
      translator = load
      translator.translate string, :to => 'zh-CHT'
    end
  end
end