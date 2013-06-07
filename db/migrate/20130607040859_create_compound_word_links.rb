class CreateCompoundWordLinks < ActiveRecord::Migration
  def change
    create_table :compound_word_links do |t|
      t.integer :compound_id
      t.integer :word_id

      t.timestamps
    end
  end
end
