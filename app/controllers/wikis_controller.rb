class WikisController < ApplicationController

  def index
    @wikis = policy_scope(Wiki)
  end

  def show
    @wiki = Wiki.find(params[:id])
    index_redirect
    if @wiki.private?
      authorize @wiki
    end
  end

  def new
    @wiki = Wiki.new
    index_redirect
    authorize @wiki
  end

  def create
    @wiki = Wiki.new(wiki_params)
    @wiki.user = current_user
    index_redirect
    authorize @wiki

    if @wiki.save
      redirect_to @wiki, notice: "Wiki was saved successfully."
    else
      flash.now[:alert] = "Error creating wiki. Please try again."
      render :new
    end
  end

  def edit
    @wiki = Wiki.find(params[:id])
    wiki_redirect
    authorize @wiki
  end

  def update
    @wiki = Wiki.find(params[:id])
    @wiki.assign_attributes(wiki_params)
    wiki_redirect
    authorize @wiki

    if @wiki.save
      flash[:notice] = "Wiki was updated."
      redirect_to @wiki
    else
      flash.now[:alert] = "Error saving wiki. Please try again."
      render :edit
    end
  end

  def destroy
    @wiki = Wiki.find(params[:id])
    wiki_redirect
    authorize @wiki

    if @wiki.destroy
      flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = "There was an error deleting the wiki."
      render :show
    end
  end

  private

  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to @rescue_redirect
  end

  def wiki_redirect
    unless user_signed_in?
      @rescue_redirect = new_user_session_path
    else
      @rescue_redirect = @wiki
    end
  end

  def index_redirect
    unless user_signed_in?
      @rescue_redirect = new_user_session_path
    else
      @rescue_redirect = wikis_path
    end
  end

end
