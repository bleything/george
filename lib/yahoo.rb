require 'rc_rest'

##
# Abstract class for implementing Yahoo APIs.
#
# http://developer.yahoo.com/

class Yahoo < RCRest

  ##
  # Yahoo error class.

  class Error < RCRest::Error; end

  ##
  # Web services initializer.
  #
  # The +appid+ is the Application ID that uniquely identifies your
  # application.  See: http://developer.yahoo.com/faq/index.html#appid
  #
  # Concrete web services implementations need to set the following instance
  # variables then call super:
  #
  # +host+:: API endpoint hostname
  # +service_name+:: service name
  # +version+:: service name version number
  # +method+:: service method call
  #
  # See http://developer.yahoo.com/search/rest.html

  def initialize(appid)
    @appid = appid
    @url = URI.parse "http://#{@host}/#{@service_name}/#{@version}/#{@method}"
  end

  ##
  # Extracts and raises an error from +xml+, if any.

  def check_error(xml)
    err = xml.elements['Error']
    raise Error, err.elements['Message'].text if err
  end

  ##
  # Creates a URL from the Hash +params+.  Automatically adds the appid and
  # sets the output type to 'xml'.

  def make_url(params)
    params[:appid] = @appid
    params[:output] = 'xml'

    super params
  end

end

