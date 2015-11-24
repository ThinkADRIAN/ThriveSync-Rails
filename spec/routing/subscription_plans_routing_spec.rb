require "rails_helper"

RSpec.describe SubscriptionPlansController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/subscription_plans").to route_to("subscription_plans#index")
    end

    it "routes to #new" do
      expect(:get => "/subscription_plans/new").to route_to("subscription_plans#new")
    end

    it "routes to #show" do
      expect(:get => "/subscription_plans/1").to route_to("subscription_plans#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/subscription_plans/1/edit").to route_to("subscription_plans#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/subscription_plans").to route_to("subscription_plans#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/subscription_plans/1").to route_to("subscription_plans#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/subscription_plans/1").to route_to("subscription_plans#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/subscription_plans/1").to route_to("subscription_plans#destroy", :id => "1")
    end

  end
end
