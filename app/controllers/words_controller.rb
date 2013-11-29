class WordsController < ApplicationController
  def show
    @searched = params[:q].try(:strip)
    word_id = params[:id]

    @word = Word.includes(:compounds, :more_info, :subwords).find_by(id: word_id)

    subwords = @word.subwords
    @ordered_subs = order_subwords(subwords, @word) if subwords.present?
    # @ordered_subs = subwords

    if request.headers['X-PJAX']
      render :layout => false
    end

  end

  def retranslate
    text = params[:t].try(:strip)
    respond_to do |format|
      if translation = Translation.find_by(to_translate: text)
        translation.destroy! #remove the translation
      end

      translated_text = Translator.to_en text

      output = {
        "status"       => "Successful",
        "to_translate" => text,
        "translated"   => translated_text
      }

      format.all { render json: output, notice: "Translation refresh completed successfully."}
    end
    
  end


  private

  #Remove duplicates and order the subword based on the word itself
  def order_subwords(to_order, main_word)

    to_order.select{|x| x.chars_trad.length > 1}.each do |to_remove|
      to_remove.chars_trad.split(//).each do |remove_this|
        to_order = to_order.reject{|x| (x.chars_trad == remove_this)}
      end
    end

    output = []
    
    #Re order the output
    main_word.chars_trad.split(//).each do |each_char|
      to_order.reject!{|x| output << x if x.chars_trad.include? each_char }
    end
    output
  end
end
