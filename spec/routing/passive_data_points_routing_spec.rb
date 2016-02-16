require "rails_helper"

RSpec.describe PassiveDataPointsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/passive_data_points").to route_to("passive_data_points#index")
    end

    it "routes to #new" do
      expect(:get => "/passive_data_points/new").to route_to("passive_data_points#new")
    end

    it "routes to #show" do
      expect(:get => "/passive_data_points/1").to route_to("passive_data_points#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/passive_data_points/1/edit").to route_to("passive_data_points#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/passive_data_points").to route_to("passive_data_points#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/passive_data_points/1").to route_to("passive_data_points#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/passive_data_points/1").to route_to("passive_data_points#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/passive_data_points/1").to route_to("passive_data_points#destroy", :id => "1")
    end

  end
end
