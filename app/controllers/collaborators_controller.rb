class CollaboratorsController < ApplicationController
  before_action :authenticate_user!

  def new
    @wiki = Wiki.find(params[:wiki_id])
    @collaborator = Collaborator.new
    @rescue_redirect = new_charge_path
    authorize @collaborator
  end

  def create
    @wiki = Wiki.find(params[:wiki_id])
    @collaborator = @wiki.collaborators.build(user_id: collaborator_user.ids)
    @rescue_redirect = new_charge_path
    authorize @collaborator

    if @collaborator.save
      flash[:notice] = "#{collaborator_user.name} has been added as a collaborator."
      redirect_to @wiki
    else
      flash.now[:alert] = "There was an error adding the collaborator. Please try again."
      render :new
    end
  end

  def destroy
    @collaborator = Collaborator.find(params[:id])
    @rescue_redirect = new_charge_path
    authorize @collaborator

    if @collaborator.destroy
      flash[:notice] = "Collaboration has ceased!"
      redirect_to @collaborator.wiki
    else
      flash.now[:alert] = "There was an error removing the collaborator."
      redirect_to @collaborator.wiki
    end
  end

  private

  def collaborator_user
    collaborator_email = params[:collaborator][:user]
    User.where(email: collaborator_email)
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to @rescue_redirect
  end
end
