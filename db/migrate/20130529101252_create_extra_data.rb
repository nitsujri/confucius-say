class CreateExtraData < ActiveRecord::Migration
  def change
    create_table :extra_data do |t|
      t.text :data
      t.references :storable, :polymorphic => true
      # t.integer :storable_id
      # t.string :storable_type

      t.timestamps
    end

    add_index :extra_data, [:storable_type, :storable_id]
  end
end
