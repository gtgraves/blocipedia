class CollaboratorsController < ApplicationController
  before_action :authenticate_user!

  def new
    @wiki = Wiki.find(params[:wiki_id])
    @collaborator = @wiki.collaborators.new
    @rescue_redirect = @wiki
    authorize @collaborator
  end

  def create
    @wiki = Wiki.find(params[:wiki_id])
    @collaborator = @wiki.collaborators.new
    @collaborator.user = User.find_by(email: params[:collaborator][:user_id])
    @rescue_redirect = @wiki
    authorize @collaborator

    if @collaborator.save
      flash[:notice] = "#{@collaborator.user.name} has been added as a collaborator."
      redirect_to @wiki
    else
      flash.now[:alert] = "There was an error adding the collaborator. Please try again."
      render :new
    end
  end

  def destroy
    @wiki = Wiki.find(params[:wiki_id])
    @collaborator = Collaborator.find(params[:id])
    @rescue_redirect = @wiki
    authorize @collaborator

    if @collaborator.destroy
      flash[:notice] = "Collaboration has ceased!"
      redirect_to @wiki
    else
      flash.now[:alert] = "There was an error removing the collaborator."
      redirect_to @wiki
    end
  end

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    user = current_user
    unless user.admin? || user.premium?
      redirect_to new_charge_path
    else
      redirect_to @rescue_redirect
    end
  end
end
