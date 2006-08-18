# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  def prepare_map(options = {})
    map = Cartographer::Gmap.new('map')
    
    # set up defaults
    map.controls = [:type, :large]
    map.type = :hybrid
    map.center = [39.70718665682654, -94.482421875]
    map.zoom = 4
    
    # override defaults with passed-in options
    options.each do |k,v|
      map.send "#{k}=", v
    end
    
    return map
  end
end