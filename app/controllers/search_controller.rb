class SearchController < ApplicationController
  def index
    @searched = params[:q]

    @results = [Word.first, Word.find(2)]
  end
end
