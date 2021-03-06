require 'rc_rest'

##
# Library for looking up coordinates with Google's Geocoding API.
#
# http://www.google.com/apis/maps/documentation/#Geocoding_HTTP_Request

class GoogleGeocode < RCRest

  ##
  # Base error class

  class Error < RCRest::Error; end

  ##
  # Raised when you try to locate an invalid address.

  class AddressError < Error; end

  ##
  # Raised when you use an invalid key.

  class KeyError < Error; end

  ##
  # Location struct

  Location = Struct.new :address, :latitude, :longitude

  ##
  # Creates a new GoogleGeocode that will use Google Maps API key +key+.  You
  # can sign up for an API key here:
  #
  # http://www.google.com/apis/maps/signup.html

  def initialize(key)
    @key = key
    @url = URI.parse 'http://maps.google.com/maps/geo'
  end

  ##
  # Locates +address+ returning a Location struct.

  def locate(address)
    get :q => address
  end

  ##
  # Extracts a Location from +xml+.

  def parse_response(xml)
    l = Location.new

    l.address   = xml.elements['/kml/Response/Placemark/address'].text

    coordinates = xml.elements['/kml/Response/Placemark/Point/coordinates'].text
    l.longitude, l.latitude, = coordinates.split(',').map { |v| v.to_f }

    return l
  end

  ##
  # Extracts and raises an error from +xml+, if any.

  def check_error(xml)
    status = xml.elements['/kml/Response/Status/code'].text.to_i
    case status
    when 200 then # ignore, ok
    when 500 then
      raise Error, 'server error'
    when 601 then
      raise AddressError, 'missing address'
    when 602 then
      raise AddressError, 'unknown address'
    when 603 then
      raise AddressError, 'unavailable address'
    when 610 then
      raise KeyError, 'invalid key'
    when 620 then
      raise KeyError, 'too many queries'
    else
      raise Error, "unknown error #{status}"
    end
  end

  ##
  # Creates a URL from the Hash +params+.  Automatically adds the key and
  # sets the output type to 'xml'.

  def make_url(params)
    params[:key] = @key
    params[:output] = 'xml'

    super params
  end

end

##
# A Location contains the following fields:
#
# +latitude+:: Latitude of the location
# +longitude+:: Longitude of the location
# +address+:: Street address of the result.

class GoogleGeocode::Location

  ##
  # The coordinates for this location.

  def coordinates
    [latitude, longitude]
  end

end

