class AddSoundUrlToWordData < ActiveRecord::Migration
  def change
    add_column :word_data, :sound_url, :string
  end
end
