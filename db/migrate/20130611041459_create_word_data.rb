class CreateWordData < ActiveRecord::Migration
  def change
    create_table :word_data do |t|
      t.integer :word_id
      t.string :usage
      t.string :part_of_speech
      t.integer :stroke_count
      t.string :radical
      t.integer :level

      t.timestamps
    end

    add_index :word_data, :word_id
  end
end
