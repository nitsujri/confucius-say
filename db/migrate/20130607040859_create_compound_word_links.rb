class CreateCompoundWordLinks < ActiveRecord::Migration
  def change
    create_table :compound_word_links do |t|
      t.integer :compound_id
      t.integer :word_id

      t.timestamps
    end

    add_index :compound_word_links, :compound_id
    add_index :compound_word_links, :word_id
  end
end
