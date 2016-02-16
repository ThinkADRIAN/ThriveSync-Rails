require "rails_helper"

RSpec.describe PassiveSleepsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/passive_sleeps").to route_to("passive_sleeps#index")
    end

    it "routes to #new" do
      expect(:get => "/passive_sleeps/new").to route_to("passive_sleeps#new")
    end

    it "routes to #show" do
      expect(:get => "/passive_sleeps/1").to route_to("passive_sleeps#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/passive_sleeps/1/edit").to route_to("passive_sleeps#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/passive_sleeps").to route_to("passive_sleeps#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/passive_sleeps/1").to route_to("passive_sleeps#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/passive_sleeps/1").to route_to("passive_sleeps#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/passive_sleeps/1").to route_to("passive_sleeps#destroy", :id => "1")
    end

  end
end
