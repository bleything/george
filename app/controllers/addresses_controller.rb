class AddressesController < ApplicationController
  def add
    redirect_to hub_url unless request.post?
    
    addr = Address.new(params[:address]).save

    redirect_to hub_url
  end
  
  def map
    @address = Address.find(params[:address], :include => 'geocodings') rescue nil
    redirect_to hub_url and return unless @address
    
    @map = prepare_map
    
    @address.geocodings.each do |code|
      info_window = []
      info_window << "<strong>#{code.name}</strong>"
      info_window << "(#{code.coords_as_string})"
      info_window << "Score: #{code.score}"
  
      @map.markers << Cartographer::Gmarker.new(
        :map         => @map,
        :name        => code.name,
        :position    => code.coordinates,
        :info_window => info_window.join("<br />\n")
      )
    end
    
    @map.center = @address.centroid.coordinates
    @map.zoom   = 14
  end
end
