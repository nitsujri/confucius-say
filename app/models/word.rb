class Word < ActiveRecord::Base
  validates :chinese_trad, :presence => true, :uniqueness => true
  validates :chinese_simp, :presence => true

  has_one :extra_data, :as => :storable


  searchable do
    string :chinese_trad
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

end