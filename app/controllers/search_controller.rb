class SearchController < ApplicationController

  def index
    @searched = params[:q].strip
    
    #we have english only, so let's use bing translate ==============================
    if @searched.ascii_only?
      begin

        translated_chars = Translator.to_cht @searched

        @translated_to = translated_chars
      rescue BingTranslator::Exception => e
        @error_msg = e.message
      end
    else
      translated_chars = @searched
    end

    unless translated_chars.blank?
      #look for exact match ===========================================================
      @db_results = Word.where('chars_trad = ? OR chars_simp = ?', translated_chars, translated_chars)

      #if we found an exact match go to the result (i don't care about anyone else) ===
      if @db_results.count == 1 and params[:all] != "true"
        redirect_to word_path(@db_results.first, :q => @searched)
        return
      end

      #see if we can find that word as part of another sentence =======================
      if params[:all] == "true"
        #add in LIKE entries, but have the exact match entries removed
        @db_results += Word.where('(chars_trad LIKE ? OR chars_simp LIKE ?) AND id <> ?', "%#{translated_chars}%", "%#{translated_chars}%", @db_results.first.id).limit(30)
      end

      # If they're still blank maybe we're dealing with a sentence of chinese =========
      if @db_results.blank?
        split_sent    = translated_chars.split(//)
        @char_by_char = Word.where('chars_trad IN (?) OR chars_simp IN (?)', split_sent, split_sent)

        if @char_by_char.present?
          @char_by_char            = sort_results(translated_chars, @char_by_char)
          @char_by_char_translated = Translator.to_en translated_chars
        end
        
      end
    end

    if request.headers['X-PJAX']
      render :layout => false
    end

  end

  # def autocomplete
  #   output = unless params[:q].ascii_only?
  #     words  = Word.where('(chars_trad LIKE ? OR chars_simp LIKE ?)', "%#{params[:q]}%", "%#{params[:q]}%")
  #     words.map do |w|
  #       unless w.simp_diff?
  #         chinese = w.chars_trad
  #       else
  #         chinese = w.chars_trad + "(" + w.chars_simp + ")"
  #       end

  #       { 
  #         "id" => w.id,
  #         "name" => chinese,
  #       }
  #     end
  #   else
  #     Word.search do
  #       keywords params[:q]
  #       paginate :page => params[:page] || 1, :per_page => 50
  #     end.results.map do |r|
  #       {
  #         "id" => r.id,
  #         "name" => r.english,
  #       }
  #     end
  #   end
  #   respond_to do |format|
  #     format.html { render :json => output }
  #     format.js { render :json => output }
  #   end
  # end

  private

  #For sentences, helps sort results by how they were searched
  def sort_results(sort_by, to_sort)
    output = []
    sort_by.split(//).each do |s|
      if word = to_sort.select { |r| r.chars_trad == s || r.chars_simp == s}
        output += word
      end
    end

    output
  end
end
