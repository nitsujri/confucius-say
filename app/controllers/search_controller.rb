class SearchController < ApplicationController
  def index
    @searched = params[:q]
  end
end
