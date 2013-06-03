class SearchController < ApplicationController
  def index
    @searched = params[:q]
    @page_num = params[:page]
    
    if @searched.ascii_only?
      #we have english
      @solr = Word.search do
        keywords params[:q]
        paginate :page => params[:page] || 1, :per_page => 50
      end
    else
      #we have chinese
      @chinese_words = Word.where('chars_trad = ? OR chars_simp = ?', params[:q], params[:q])
      @chinese_words += Word.where('(chars_trad LIKE ? OR chars_simp LIKE ?) AND id <> ?', "%#{params[:q]}%", "%#{params[:q]}%", @chinese_words.first.id)
    end

  end
end
