class ConvertLatLongToFloat < ActiveRecord::Migration
  def self.up
    change_column :geocodings, :latitude,  :float
    change_column :geocodings, :longitude, :float
    
    count = Address.count
    Address.find_all.each_with_index {|a,i| 
      puts "-- Geocoding address #{i+1} of #{count}"
      a.regeocode! 
    }
  end

  def self.down
    change_column :geocodings, :latitude,  :string
    change_column :geocodings, :longitude, :string
    
    count = Address.count
    Address.find_all.each_with_index {|a,i| 
      puts "-- Geocoding address #{i+1} of #{count}"
      a.regeocode! 
    }
  end
end