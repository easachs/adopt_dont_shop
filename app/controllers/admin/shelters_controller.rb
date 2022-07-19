class Admin::SheltersController < ApplicationController
  def index
    @shelters = Shelter.order_by_alpha
    @pending = Shelter.with_pending_applications
  end

  def show
    @shelter = Shelter.name_and_address(params[:id])
  end
end
