class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_profile_params)
      redirect_to profile_path, notice: 'Profile updated successfully.'
    else
      render :edit
    end
  end

  private

  def user_profile_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone_numbers_attributes => [:id, :number, :_destroy])
  end
end