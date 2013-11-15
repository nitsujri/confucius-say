class AddIndexToWords < ActiveRecord::Migration
  def change
    add_index :words, :chars_trad
    add_index :words, :chars_simp
  end
end
