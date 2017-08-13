class UsersController < ApplicationController
  before_action :authenticate_user!

  def downgrade
    flash[:alert] = "You have cancelled your premium subscription #{current_user.name}. We are sorry to see you go."
    remove_private_wikis
    current_user.standard!
    redirect_to root_path
  end

  private

  def remove_private_wikis
    current_user.wikis.each do |wiki|
      if wiki.private == true
        wiki.private = false
        wiki.save!
      end
    end
  end

end
