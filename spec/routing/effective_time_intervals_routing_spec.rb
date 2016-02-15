require "rails_helper"

RSpec.describe EffectiveTimeIntervalsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/effective_time_intervals").to route_to("effective_time_intervals#index")
    end

    it "routes to #new" do
      expect(:get => "/effective_time_intervals/new").to route_to("effective_time_intervals#new")
    end

    it "routes to #show" do
      expect(:get => "/effective_time_intervals/1").to route_to("effective_time_intervals#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/effective_time_intervals/1/edit").to route_to("effective_time_intervals#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/effective_time_intervals").to route_to("effective_time_intervals#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/effective_time_intervals/1").to route_to("effective_time_intervals#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/effective_time_intervals/1").to route_to("effective_time_intervals#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/effective_time_intervals/1").to route_to("effective_time_intervals#destroy", :id => "1")
    end

  end
end
