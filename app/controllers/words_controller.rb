class WordsController < ApplicationController
  def show
    word_id = params[:id]

    @word = Word.find_by(id: word_id)
  end
end
