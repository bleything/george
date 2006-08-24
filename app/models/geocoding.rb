class Geocoding < ActiveRecord::Base
  belongs_to :address

  def lat
    self.latitude.to_f
  end
  
  def long
    self.longitude.to_f
  end
  
  def coordinates
    sprintf( "%0.4f, %0.4f", self.lat, self.long )
  end
  
  def score
    "not implemented"
  end
end
