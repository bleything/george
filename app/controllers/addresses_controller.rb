class AddressesController < ApplicationController
  def add
    redirect_to hub_url unless request.post?
    
    addr = Address.new(params[:address])
    addr.geocode!
    addr.save
    
    redirect_to hub_url
  end
end
