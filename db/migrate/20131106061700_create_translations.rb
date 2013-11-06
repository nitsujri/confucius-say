class CreateTranslations < ActiveRecord::Migration
  def change
    create_table :translations do |t|
      t.string :to_lang
      t.string :from_lang
      t.text :to_translate
      t.text :translated

      t.timestamps
    end

    add_index :translations, :to_translate, :length => 10
  end
end
