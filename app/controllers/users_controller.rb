class UsersController < ApplicationController
  before_action :authenticate_user!

  def downgrade
    flash[:alert] = "You have cancelled your premium subscription #{current_user.name}. We are sorry to see you go."
    current_user.standard!
    redirect_to root_path
  end

end
