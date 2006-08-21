class Address < ActiveRecord::Base
  has_many :geocodings, :dependent => :destroy

  validates_presence_of :name, :street_address, :city, :state, :zip
  
  def regeocode!
    self.geocodings.each {|g| g.destroy}
    self.geocode!
    self.reload
  end    

  def geocode!
    GEOCODERS.each do |service, coder|
      begin
        location = coder.locate(self)
      rescue Exception => e
        next
      end

      geocoding = Geocoding.new
      
      case service
      when :geocoderus
        geocoding.returned_address = location.address
        geocoding.confidence = 'not implemented'
      when :yahoo
        location = location.first
        geocoding.returned_address = [location.address, location.city, location.state].join(', ') + " #{location.zip}"
        geocoding.confidence = location.precision
      when :google
        geocoding.returned_address = location.address
        geocoding.confidence = 'not implemented'
      when :metacarta
        geocoding.returned_address = 'not implemented'
        geocoding.confidence = location.confidence
      when :ontok
        geocoding.returned_address = [location.address, location.city, location.state].join(', ') + " #{location.zip}"
        geocoding.confidence = location.score
      end

      geocoding.service   = service.to_s
      geocoding.longitude = location.longitude
      geocoding.latitude  = location.latitude
            
      geocoding.save!
      self.geocodings << geocoding
    end
  end
  
  def to_s
    return [self.street_address, self.city, self.state, self.zip].join(', ')
  end
  
  def centroid
    triangles = combine(self.geocodings, 3)
    
    areas     = []
    centroids = []
    ratios    = []
    
    triangles.each do |triangle|
      # longitude is x coord
      # latitude is y coord
      
      # triangle area is [(x2 - x1)(y3 - y1) - (x3 - x1)(y2 - y1)] / 2
      areas << ((triangle[1].longitude - triangle[0].longitude) * (triangle[2].latitude - triangle[0].latitude)-(triangle[2].longitude - triangle[0].longitude) * (triangle[1].latitude - triangle[0].latitude)) / 2
      
      # centroid is x = (x1 + x2 + x3) / 3, y = (y1 + y2 + y3) / 3
      centroids << [(triangle[0].longitude + triangle[1].longitude + triangle[2].longitude) / 3,
                    (triangle[0].latitude + triangle[1].latitude + triangle[2].latitude) / 3
                   ]
    end
    
    polygon_area = areas.inject{|sum, area| sum + area}
    
    areas.each do |area|
      ratios << area/polygon_area
    end
    
    centroid_longitude = 0
    centroid_latitude  = 0
    
    centroids.each_with_index do |centroid, index|
      centroid_longitude += centroid[0] * ratios[index]
      centroid_latitude  += centroid[1] * ratios[index]
    end
    
    return [centroid_latitude, centroid_longitude]
  end
end