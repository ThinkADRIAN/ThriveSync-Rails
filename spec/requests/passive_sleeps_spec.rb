require 'rails_helper'

RSpec.describe "PassiveSleeps", type: :request do
  describe "GET /passive_sleeps" do
    it "works! (now write some real specs)" do
      get passive_sleeps_path
      expect(response).to have_http_status(200)
    end
  end
end
