require 'rails_helper'

RSpec.describe "EffectiveTimeIntervals", type: :request do
  describe "GET /effective_time_intervals" do
    it "works! (now write some real specs)" do
      get effective_time_intervals_path
      expect(response).to have_http_status(200)
    end
  end
end
