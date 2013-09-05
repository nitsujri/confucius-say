class SearchController < ApplicationController
  def index
    @searched = params[:q]
    @page_num = params[:page]
    
    #we have english only, so let's use bing translate
    if @searched.ascii_only?
      begin
        chars = Translator.to_cht @searched
      rescue BingTranslator::Exception => e
        @error_msg = e.message
      end
    else
      chars = @searched
    end

    #look for exact match
    @chinese_words = Word.where('chars_trad = ? OR chars_simp = ?', chars, chars)

    unless @chinese_words.blank?
      #add in LIKE entries, but have the exact match entries removed
      @chinese_words += Word.where('(chars_trad LIKE ? OR chars_simp LIKE ?) AND id <> ?', "%#{chars}%", "%#{chars}%", @chinese_words.first.id)
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
