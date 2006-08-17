class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.column 'name',           :string
      t.column 'street_address', :string
      t.column 'city',           :string
      t.column 'state',          :string
      t.column 'zip',            :string
    end
  end

  def self.down
    drop_table :addresses
  end
end
