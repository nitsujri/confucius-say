class Word < ActiveRecord::Base
  validates :chinese_trad, :presence => true, :uniqueness => true
  validates :chinese_simp, :presence => true


  searchable do
    string :chinese_trad
    text :english do
      english.gsub(/\(.*\)/, "") if english.present?
    end
  end
end
