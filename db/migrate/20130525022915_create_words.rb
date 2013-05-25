class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :chinese_trad
      t.string :chinese_simp
      t.string :jyutping
      t.string :yale
      t.string :pinyin
      t.string :english

      t.timestamps
    end
  end
end
