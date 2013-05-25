class SearchController < ApplicationController
  def index
    @searched = params[:q]
    @page_num = params[:page]
    
    @solr = Word.search do
      keywords params[:q]
      paginate :page => params[:page] || 1, :per_page => 50
    end
  end
end
