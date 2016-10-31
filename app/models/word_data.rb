#renamed as more_info in relationship

class WordData < ActiveRecord::Base
  validates :word_id, presence: true
  
  belongs_to :word
end
