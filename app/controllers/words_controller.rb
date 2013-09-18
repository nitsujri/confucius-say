class WordsController < ApplicationController
  def show
    word_id = params[:id]

    @word = Word.includes(:compounds, :more_info).find_by(id: word_id)
  end
end
