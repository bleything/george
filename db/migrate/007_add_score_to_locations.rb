class AddScoreToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :score, :string
  end

  def self.down
    remove_column :locations, :score
  end
end
