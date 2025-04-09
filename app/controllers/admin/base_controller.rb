class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!
  layout 'admin'

  private

  def require_admin!
    unless current_user&.admin?
      flash[:error] = "You are not authorized to access this area."
      redirect_to root_path
    end
  end
end