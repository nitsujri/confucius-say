class CompoundWordLink < ActiveRecord::Base
  belongs_to :word
  belongs_to :compound, :class_name => "Word"
end
