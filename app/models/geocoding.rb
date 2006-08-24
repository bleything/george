class Geocoding < Location
  belongs_to :address
  
  def score
    "not implemented"
  end
end
