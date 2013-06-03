class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :chars_trad
      t.string :chars_simp
      t.string :jyutping
      t.string :yale
      t.string :pinyin
      t.text :english

      t.timestamps
    end
  end
end
