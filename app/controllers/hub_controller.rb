class HubController < ApplicationController
  def index
    @map = prepare_map
  end
end