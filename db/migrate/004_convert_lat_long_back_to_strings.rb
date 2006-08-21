class ConvertLatLongBackToStrings < ActiveRecord::Migration
  def self.up
    change_column :geocodings, :latitude,  :string
    change_column :geocodings, :longitude, :string
    
    Address.find_all.each {|a| a.regeocode! }
  end

  def self.down
    change_column :geocodings, :latitude,  :float
    change_column :geocodings, :longitude, :float
    
    Address.find_all.each {|a| a.regeocode! }
  end
end
