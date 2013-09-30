class AddAttachmentToWords < ActiveRecord::Migration
  def change
    add_attachment :words, :stroke_image
  end
end
