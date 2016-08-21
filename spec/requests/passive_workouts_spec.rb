require 'rails_helper'

RSpec.describe "PassiveWorkouts", type: :request do
  describe "GET /passive_workouts" do
    it "works! (now write some real specs)" do
      get passive_workouts_path
      expect(response).to have_http_status(200)
    end
  end
end
