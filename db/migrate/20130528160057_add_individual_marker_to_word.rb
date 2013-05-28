class AddIndividualMarkerToWord < ActiveRecord::Migration
  def change
    add_column :words, :single_char, :bool
  end
end
