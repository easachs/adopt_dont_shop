class Admin::SheltersController < ApplicationController
  def index
    @shelters = Shelter.order_by_alpha
    @pending = Shelter.with_pending_applications
  end
end
