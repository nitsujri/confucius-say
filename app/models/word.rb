class Word < ActiveRecord::Base
  validates :chars_trad, :presence => true, :uniqueness => true
  validates :chars_simp, :presence => true

  has_one :extra_data, :as => :storable


  searchable do
    # not good enough to use solr on chinese
    # string :chars_trad
    # string :chars_simp
    text :english do
      english.gsub(/\(.*\)/, "") if english.present?
    end
  end

  def set_data(key, data)
    key = key.to_sym #make sure it's a symbol, to avoid dups

    self.extra_data = ExtraData.new unless self.extra_data.present?

    unless self.extra_data.data.blank?
      self.extra_data.data = self.extra_data.data.merge({
        key => data
      })
    else
      self.extra_data.data = { key => data }
    end

    self.extra_data.save!
  end

  def get_data(key)
    key = key.to_sym
    self.extra_data.data[key]
  end

  # Current example of fully stuffed data

  # {
  #   :char           => noko_html.at_css('.word.script').try(:text),
  #   :jyutping       => noko_html.at_css('.cardjyutping').try(:text),
  #   :pinyin         => noko_html.at_css('.cardpinyin').try(:text),
  #   :english        => noko_html.at_xpath('//*[@class="wordmeaning"]/text()').try(:text).try(:strip),
  #   :part_of_speech => noko_html.at_xpath('//*[@class="posicon"]/@title').try(:text),
  #   :stroke_count   => noko_html.at_css('.charstrokecount').try(:text),
  #   :radical        => noko_html.at_css('.charradical').try(:text),
  #   :level          => noko_html.at_css('.charlevel').try(:text),
  #   :compounds      => {
  #     :info => {
  #       :full_compounds_list_url => fd_url
  #     },
  #     :the_compounds => {
  #       :full_detail_url => fd_url,
  #       :chars_trad => { 
  #         :type => "linkedchar", 
  #         :char_trad => c.text, 
  #         :full_detail_url => c[:href] 
  #       },
  #       :jyutping   => jyutping,
  #       :pinyin     => pinyin,
  #       :english    => english,
  #       :usage      => usage,
  #     },
  #   },
  #   :examples       => {
  #     :full_detail_url   => fd_url,
  #     :sound_example_url => sound_url,
  #     :chars_trad        => {
  #       :chars_trad => a.text, 
  #       :full_detail_url => a[:href]
  #     },
  #     :useage            => usage
  #   },
  # }

end