require 'rails_helper'

RSpec.describe "SubscriptionPlans", type: :request do
  describe "GET /subscription_plans" do
    it "works! (now write some real specs)" do
      get subscription_plans_path
      expect(response).to have_http_status(200)
    end
  end
end
