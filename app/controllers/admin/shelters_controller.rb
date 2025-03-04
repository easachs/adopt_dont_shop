class Admin::SheltersController < ApplicationController
  def index
    @shelters = Shelter.order_by_alpha
    @pending = Shelter.with_pending_applications.alpha_sort
  end

  def show
    @shelter = Shelter.find(params[:id])
    @shelter_address = Shelter.name_and_address(params[:id])
    @avg_pet_age = @shelter.avg_age
    @adoptable = @shelter.num_adoptable
    @approved = @shelter.num_approved
    @action_reqd = @shelter.action_required
  end
end
