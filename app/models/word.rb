class Word < ActiveRecord::Base
  validates :chinese_trad, :presence => true, :uniqueness => true
  validates :chinese_simp, :presence => true
end
