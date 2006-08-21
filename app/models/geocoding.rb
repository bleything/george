class Geocoding < ActiveRecord::Base
  belongs_to :address

  def lat
    self.latitude.to_f
  end
  
  def long
    self.longitude.to_f
  end
end
