class ExtraData < ActiveRecord::Base
  belongs_to :storable, polymorphic: true

  serialize :data
end
