class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :word_path

  def word_path(word)
    "/" + urlify_ch(word.chars_trad) + "-" + urlify_en(word.english) + "/" + word.id.to_s
  end

  private

  def urlify_ch(text)
    text.gsub(/\U+FFEF\U+FFBC/, "-")
  end

  def urlify_en(text)
    text.gsub(/\(.*\)/, "").gsub(/[^a-zA-Z0-9\s]+/, "").strip.gsub(/\s/, "-").downcase
  end
end
