require 'yahoo'

##
# Yahoo geocoding API.
#
# http://developer.yahoo.com/maps/rest/V1/geocode.html

class Yahoo::Geocode < Yahoo

  ##
  # Location result Struct.

  Location = Struct.new :latitude, :longitude, :address, :city, :state, :zip,
                        :country, :precision, :warning

  def initialize(*args) # :nodoc:
    @host = 'api.local.yahoo.com'
    @service_name = 'MapsService'
    @version = 'V1'
    @method = 'geocode'
    super
  end

  ##
  # Returns a Location for +address+.
  #
  # The +address+ can be any of:
  # * city, state
  # * city, state, zip
  # * zip
  # * street, city, state
  # * street, city, state, zip
  # * street, zip

  def locate(address)
    get :location => address
  end

  def parse_response(xml) # :nodoc:
    addresses = []

    xml.elements['ResultSet'].each do |r|
      address = Location.new

      address.precision = r.attributes['precision']

      if r.attributes.include? 'warning' then
        address.warning = r.attributes['warning']
      end

      address.latitude = r.elements['Latitude'].text.to_f
      address.longitude = r.elements['Longitude'].text.to_f

      address.address = r.elements['Address'].text
      address.city = r.elements['City'].text
      address.state = r.elements['State'].text
      address.zip = r.elements['Zip'].text
      address.country = r.elements['Country'].text

      addresses << address
    end

    return addresses
  end

end

##
# A Location contains the following fields:
#
# +latitude+:: Latitude of the location
# +longitude+:: Longitude of the location
# +address+:: Street address of the result, if a specific location could be
#             determined
# +city+:: City in which the result is located
# +state+:: State in which the result is located
# +zip+:: Zip code, if known
# +country+:: Country in which the result is located
# +precision+:: The precision of the address used for geocoding
# +warning+:: If the exact address was not found, the closest available match
#
# Precision can be one of the following, from most specific to most general:
#
# * address
# * street
# * zip+4
# * zip+2
# * zip
# * city
# * state
# * country

class Yahoo::Geocode::Location

  ##
  # Returns an Array with latitude and longitude.

  def coordinates
    [latitude, longitude]
  end

end

