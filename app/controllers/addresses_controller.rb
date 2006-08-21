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
      @map.markers << Cartographer::Gmarker.new(
        :map         => @map,
        :name        => code.service,
        :position    => [code.lat, code.long],
        :info_window => code.service
      )
    end
    
    @map.center = @address.centroid
    @map.zoom   = 13
  end
end
