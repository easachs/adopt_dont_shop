class Admin::PetAppsController < ApplicationController

  def update
    @app = App.find(params[:id])
    @petapp = @app.pet_apps.find_by(pet_id: petapp_params[:pet_id])
    @petapp.update(petapp_params)
    redirect_to "/admin/apps/#{@app.id}"
  end

  private
  def petapp_params
    params.permit(:pet_id, :approval)
  end
end  
  