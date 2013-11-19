class ExamplesController < ApplicationController
  layout "application_no_s"
  def index
    @examples = Word.includes(:more_info).where("word_data.sound_url IS NOT NULL").references(:word_data)
  end

end
