class AddEnglish2ToWords < ActiveRecord::Migration
  def change
    add_column :words, :english_2, :text
  end
end
