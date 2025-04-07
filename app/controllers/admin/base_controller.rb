class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  layout 'admin'

  private

  def ensure_admin!
    unless current_user&.admin?
      flash[:alert] = "You are not authorized to access this area."
      redirect_to root_path
    end
  end
end