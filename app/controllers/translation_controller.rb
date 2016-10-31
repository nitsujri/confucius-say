class TranslationController < ApplicationController
  layout "application_no_s"

  def index
  end

  def translate
    text = params[:q].strip

    @output = text.split("\n").map do |line|
      {
        lookup: line.split("").map do |char|
            word = Word.find_by(chars_trad: char)

            next if word.blank?

            {
              chars_trad: char,
              jyutping: word.jyutping
            }
        end,
        translation: Translator.to_en(line)
      }
    end
  end
end
