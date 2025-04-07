require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/admin/users/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/admin/users/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/admin/users/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/admin/users/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /activate" do
    it "returns http success" do
      get "/admin/users/activate"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /deactivate" do
    it "returns http success" do
      get "/admin/users/deactivate"
      expect(response).to have_http_status(:success)
    end
  end

end
