class Address < ActiveRecord::Base
  has_many :geocodings,        :dependent => :destroy
  has_many :calculated_points, :dependent => :destroy

  validates_presence_of :name, :street_address, :city, :state, :zip
  
  def before_create
    self.geocodings        << fetch_geocodes
    self.calculated_points << calculate_points
  end
  
  def regeocode!
    self.geocodings.each {|g| g.destroy}
    self.geocodings << fetch_geocodes
    self.save!
    self.reload
  end
  
  def recalculate_points!
    self.calculated_points.each {|p| p.destroy}
    self.calculated_points << calculate_points
    self.save!
    self.reload
  end    
  
  def to_s
    return [self.street_address, self.city, self.state, self.zip].join(', ')
  end

  def centroid
    return self.calculated_points.detect {|p| p.name == 'Centroid'}
  end
  
  private
  def fetch_geocodes
    out = []

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

      geocoding.name      = service.to_s
      geocoding.longitude = location.longitude
      geocoding.latitude  = location.latitude
            
      geocoding.save!
      out << geocoding
    end
    
    return out
  end

  def calculate_points
    return [find_centroid]
  end

  def find_centroid
    return if self.geocodings.size == 0
    
    loc = CalculatedPoint.new
    loc.name = 'Centroid'
    
    if self.geocodings.size == 1 # only one point, centroid is self
      loc.latitude  = self.geocodings.first.lat
      loc.longitude = self.geocodings.first.long
    elsif self.geocodings.size == 2
      loc.latitude  = (self.geocodings.first.lat  + self.geocodings.last.lat)  / 2
      loc.longitude = (self.geocodings.first.long + self.geocodings.last.long) / 2
    else
      areas     = []
      centroids = []
      ratios    = []
    
      triangles.each do |triangle|
        # longitude is x coord
        # latitude is y coord
      
        # triangle area is [(x2 - x1)(y3 - y1) - (x3 - x1)(y2 - y1)] / 2
        areas << ((triangle[1].long - triangle[0].long) * (triangle[2].lat - triangle[0].lat)-(triangle[2].long - triangle[0].long) * (triangle[1].lat - triangle[0].lat)) / 2
      
        # centroid is x = (x1 + x2 + x3) / 3, y = (y1 + y2 + y3) / 3
        centroids << [(triangle[0].long + triangle[1].long + triangle[2].long) / 3,
                      (triangle[0].lat + triangle[1].lat + triangle[2].lat) / 3
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
    
      loc.latitude  = centroid_latitude
      loc.longitude = centroid_longitude
    end
    
    return loc
  end

  def triangles
    out = []
    
    codings = self.geocodings.dup
    root = codings.shift
    
    while codings.size >= 2 do
      out << [root, codings.shift, codings[0]]
    end
    
    return out
  end
end