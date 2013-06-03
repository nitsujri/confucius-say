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
      unless @chinese_words.blank?
        @chinese_words += Word.where('(chars_trad LIKE ? OR chars_simp LIKE ?) AND id <> ?', "%#{params[:q]}%", "%#{params[:q]}%", @chinese_words.first.id)
      else
        #there was no exact mach, go to translation system
      end
        
    end

  end

  def autocomplete
    output = unless params[:q].ascii_only?
      words  = Word.where('(chars_trad LIKE ? OR chars_simp LIKE ?)', "%#{params[:q]}%", "%#{params[:q]}%")
      words.map do |w|
        unless w.simp_diff?
          chinese = w.chars_trad
        else
          chinese = w.chars_trad + "(" + w.chars_simp + ")"
        end

        { 
          "id" => w.id,
          "name" => chinese,
        }
      end
    else
      Word.search do
        keywords params[:q]
        paginate :page => params[:page] || 1, :per_page => 50
      end.results.map do |r|
        {
          "id" => r.id,
          "name" => r.english,
        }
      end
    end
    respond_to do |format|
      format.html { render :json => output }
      format.js { render :json => output }
    end
  end
end
