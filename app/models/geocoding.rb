class Geocoding < Location
  belongs_to :address
  
  def calculate_score!
    avg = self.address.weighted_average
    
    lat_delta  = self.lat  - avg.lat
    long_delta = self.long - avg.long
    
    distance = Math.sqrt(lat_delta ** 2 + long_delta ** 2)
    
    self.score = 10 - (distance * 100)
    self.save!
    self.reload    
  end
  
  private
  
end
