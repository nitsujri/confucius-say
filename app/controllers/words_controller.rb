class WordsController < ApplicationController
  def show
    @searched = params[:q].try(:strip)
    word_id = params[:id]

    @word = Word.includes(:compounds, :more_info).find_by(id: word_id)

    if request.headers['X-PJAX']
      render :layout => false
    end

  end
end
