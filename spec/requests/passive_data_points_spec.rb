require 'rails_helper'

RSpec.describe "PassiveDataPoints", type: :request do
  describe "GET /passive_data_points" do
    it "works! (now write some real specs)" do
      get passive_data_points_path
      expect(response).to have_http_status(200)
    end
  end
end
