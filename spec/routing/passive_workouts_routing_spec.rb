require "rails_helper"

RSpec.describe PassiveWorkoutsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/passive_workouts").to route_to("passive_workouts#index")
    end

    it "routes to #new" do
      expect(:get => "/passive_workouts/new").to route_to("passive_workouts#new")
    end

    it "routes to #show" do
      expect(:get => "/passive_workouts/1").to route_to("passive_workouts#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/passive_workouts/1/edit").to route_to("passive_workouts#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/passive_workouts").to route_to("passive_workouts#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/passive_workouts/1").to route_to("passive_workouts#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/passive_workouts/1").to route_to("passive_workouts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/passive_workouts/1").to route_to("passive_workouts#destroy", :id => "1")
    end

  end
end
