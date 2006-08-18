# Defines a map header
#
# <%= GMap::Header.new('example.com').to_s %>
# or
# <%= GMap::Header.header_for(request) %>
# for a request-by-request basis.
#
# Insert the Google Map script into the header of your app.
# Allows for the IE extension for polyline drawing.

class Cartographer::Header
  include Reloadable

  attr_accessor :uri, :version
  @version = 2

  def to_s

    # initialize the html with the IE polyline VML code
    html = "\n<!--[if IE]>\n<style type=\"text/css\">v\\:* { behavior:url(#default#VML); }</style>\n<![endif]-->"
    html << "<script src='http://maps.google.com/maps?file=api&amp;v=#{version}&amp;key=#{GOOGLE_KEY}' type='text/javascript'></script>"

    return html
  end

  # get a meaningful header out of the request object
  # strip the file, just the path, ma'am.
  # such that http://blah.com/path/file becomes /path/
  def self.header_for(request, version=2)
    mh = self.new
    mh.version = version
    #uri = request.request_uri
    #uri = uri[0..uri.rindex('/')] if uri.rindex('/') < uri.length
    mh.uri = request.env["HTTP_HOST"] #+ uri
    mh.to_s
  end

end
