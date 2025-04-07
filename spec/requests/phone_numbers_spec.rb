require 'rails_helper'

RSpec.describe "PhoneNumbers", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/phone_numbers/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/phone_numbers/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/phone_numbers/destroy"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /send_verification" do
    it "returns http success" do
      get "/phone_numbers/send_verification"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /verify_code" do
    it "returns http success" do
      get "/phone_numbers/verify_code"
      expect(response).to have_http_status(:success)
    end
  end

end
