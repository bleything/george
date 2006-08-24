class AddressesController < ApplicationController
  def add
    redirect_to hub_url unless request.post?
    
    addr = Address.new(params[:address])
    addr.geocode!
    addr.save
    
    redirect_to hub_url
  end
  
  def map
    @address = Address.find(params[:address], :include => 'geocodings') rescue nil
    redirect_to hub_url and return unless @address
    
    @map = prepare_map
    
    @address.geocodings.each do |code|
      info_window = []
      info_window << "<strong>#{code.name}</strong>"
      info_window << "(#{code.coordinates})"
      info_window << "Score: #{code.score}"
  
      @map.markers << Cartographer::Gmarker.new(
        :map         => @map,
        :name        => code.name,
        :position    => [code.lat, code.long],
        :info_window => info_window.join("<br />\n")
      )
    end
    
    @map.center = @address.centroid
    @map.zoom   = 13
  end
end
