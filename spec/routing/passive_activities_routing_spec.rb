require "rails_helper"

RSpec.describe PassiveActivitiesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/passive_activities").to route_to("passive_activities#index")
    end

    it "routes to #new" do
      expect(:get => "/passive_activities/new").to route_to("passive_activities#new")
    end

    it "routes to #show" do
      expect(:get => "/passive_activities/1").to route_to("passive_activities#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/passive_activities/1/edit").to route_to("passive_activities#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/passive_activities").to route_to("passive_activities#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/passive_activities/1").to route_to("passive_activities#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/passive_activities/1").to route_to("passive_activities#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/passive_activities/1").to route_to("passive_activities#destroy", :id => "1")
    end

  end
end
