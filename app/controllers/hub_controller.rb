class HubController < ApplicationController
  def index
    @addresses = Address.find_all
    @map = prepare_map
  end
end