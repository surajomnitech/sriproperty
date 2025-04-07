class Admin::DashboardController < Admin::BaseController
  def index
    @total_users = User.count
    @recent_users = User.order(created_at: :desc).limit(5)
  end
end