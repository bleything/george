# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  def prepare_map(options = {})
    map = Cartographer::Gmap.new('map')
    
    # set up defaults
    map.controls = [:type, :large]
    map.type = :hybrid
    map.center = [39.134557, -95.537109]
    map.zoom = 4
    
    # override defaults with passed-in options
    options.each do |k,v|
      map.send "#{k}=", v
    end
    
    return map
  end
end