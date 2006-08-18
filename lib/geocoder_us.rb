require 'rc_rest'

##
# A library for lookup up coordinates with geocoder.us' API.
#
# http://geocoder.us/help/

class GeocoderUs < RCRest

  Location = Struct.new :latitude, :longitude, :address

  ##
  # Base error class

  class Error < RCRest::Error; end

  ##
  # Raised if you give an unlocatable address.

  class AddressError < Error; end

  ##
  # Raised if you give a bad username/password pair.

  class LoginError < Error; end

  ##
  # Creates a new GeocoderUs object optionally using +username+ and
  # +password+.
  #
  # You can sign up for a geocoder.us account here:
  #
  # http://geocoder.us/user/signup

  def initialize(user = nil, password = nil)
    if user and password then
      @url = URI.parse 'http://geocoder.us/member/service/rest/geocode'
      @url.user = user
      @url.password = password
    else
      @url = URI.parse 'http://rpc.geocoder.us/service/rest/geocode'
    end
  end

  ##
  # Locates +address+ and returns the address' latitude and longitude or
  # raises an AddressError.

  def locate(address)
    get :address => address
  end

  def parse_response(xml)
    location = Location.new
    location.address = xml.elements['rdf:RDF/geo:Point/dc:description'].text

    location.latitude = xml.elements['rdf:RDF/geo:Point/geo:lat'].text.to_f
    location.longitude = xml.elements['rdf:RDF/geo:Point/geo:long'].text.to_f

    return location
  end

  def check_error(xml)
    raise AddressError, xml.text if xml.text == 'couldn\'t find this address! sorry'
  end

end

##
# A Location contains the following fields:
#
# +latitude+:: Latitude of the location
# +longitude+:: Longitude of the location
# +address+:: Street address of the result.

class GeocoderUs::Location

  ##
  # The coordinates for this location.

  def coordinates
    return [latitude, longitude]
  end

end

