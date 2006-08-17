class Address < ActiveRecord::Base
  validates_presence_of :name, :street_address, :city, :state, :zip
end
