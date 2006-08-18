class CreateGeocodings < ActiveRecord::Migration
  def self.up
    create_table :geocodings do |t|
      t.column 'service',          :string
      t.column 'latitude',         :string
      t.column 'longitude',        :string
      t.column 'returned_address', :string
      t.column 'confidence',       :string

      t.column 'address_id', :integer
    end
  end

  def self.down
    drop_table :geocodings
  end
end
