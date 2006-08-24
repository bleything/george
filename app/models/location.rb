class Location < ActiveRecord::Base
  def lat
    self.latitude.to_f
  end
  
  def long
    self.longitude.to_f
  end
  
  def coordinates
    [self.lat, self.long]
  end
  
  def coords_as_string
    sprintf( "%0.4f, %0.4f", self.lat, self.long )
  end
end
