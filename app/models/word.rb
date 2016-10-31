class Word < ActiveRecord::Base

  validates :chars_trad, presence: true, uniqueness: true

  has_one :extra_data, as: :storable
  has_one :more_info, class_name: "WordData"

  has_many :compound_word_links
  has_many :compounds, through: :compound_word_links, source: :compound

  #If you want this speical one way stuff, you gotta make a reference to the other foreign key
  has_many :subword_word_links, class_name: "CompoundWordLink", foreign_key: "compound_id"
  has_many :subwords, through: :subword_word_links, source: :word

  scope :sound_ordered_info, -> { includes(:more_info).order("word_data.sound_url").reverse_order }

  has_attached_file :stroke_image,
    storage:        :s3,
    bucket:         "confucius-say",
    s3_credentials: YAML.load_file(File.join(Rails.root, "config", "aws-s3.yml")).with_indifferent_access[Rails.env],
    s3_hostname:    "Oregon"

  def simp_diff?
    self.chars_trad != self.chars_simp
  end

  def get_data(key)
    key = key.to_sym
    self.extra_data.data[key]
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
  #     :the_compounds => [{
  #       :full_detail_url => fd_url,
  #       :chars_trad      => [{ 
  #         :type            => "linkedchar", 
  #         :char_trad       => c.text, 
  #         :full_detail_url => c[:href] 
  #       }],
  #       :jyutping   => jyutping,
  #       :pinyin     => pinyin,
  #       :english    => english,
  #       :usage      => usage,
  #     }],
  #   },
  #   :examples       => [{
  #     :full_detail_url   => fd_url,
  #     :sound_example_url => sound_url,
  #     :chars_trad        => [{
  #       :chars_trad      => a.text, 
  #       :full_detail_url => a[:href]
  #     }],
  #     :useage            => usage
  #   }],
  # }

end