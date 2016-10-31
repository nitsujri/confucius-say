class DailyNewsController < ApplicationController
  layout "application_no_s"

  def index
    @daily_articles = get_daily_articles
  end

  private

  def get_daily_articles
    url = "http://www.chinanews.com/rss/importnews.xml"
    response = HTTParty.get url
    parsed_news = Nokogiri::XML response.body

    parsed_news.xpath('//item').drop(parsed_news.xpath('//item').count - 5).map do |article|
      {
        title_orig:        article.xpath('title').text,
        title:             translate_chars(article.xpath('title')),
        title_trans:       translate(article.xpath('title')),
        description_org:   article.xpath('description').text,
        description:       translate_chars(article.xpath('description')),
        description_trans: translate(article.xpath('description')),
        link:              article.xpath('link').text,
      }
    end
  end

  def translate_chars(chars)
    chars_split = chars.text.split(//)
    output = Word.where('chars_simp IN (?)', chars_split)
    sort_results(chars.text, output)
  end

  def translate(phrase)
    begin
      Translator.to_en phrase.text
    rescue => e
      e.message
    end
  end
end
