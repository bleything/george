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
end