class ConvertLatLongToFloat < ActiveRecord::Migration
  def self.up
    change_column :geocodings, :latitude, :float
    change_column :geocodings, :longitude, :float
  end

  def self.down
    change_column :geocodings, :latitude, :string
    change_column :geocodings, :longitude, :string
  end
end