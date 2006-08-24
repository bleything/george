class ConvertGeocodingsToLocationsWithSti < ActiveRecord::Migration
  def self.up
    rename_table :geocodings, :locations
    
    add_column :locations, :type, :string
    
    Location.find_all.each {|l| l.type = 'geocoding' ; l.save }
  end

  def self.down
    raise "irreversible!"
  end
end
