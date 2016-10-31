class CompoundWordLink < ActiveRecord::Base
  validates :word_id, uniqueness: { scope: :compound_id }
  validates :compound_id, uniqueness: { scope: :word_id }
  
  belongs_to :word
  belongs_to :compound, class_name: "Word"
end
