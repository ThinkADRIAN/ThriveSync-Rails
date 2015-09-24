require "rails_helper"

RSpec.describe PreDefinedCardsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/pre_defined_cards").to route_to("pre_defined_cards#index")
    end

    it "routes to #new" do
      expect(:get => "/pre_defined_cards/new").to route_to("pre_defined_cards#new")
    end

    it "routes to #show" do
      expect(:get => "/pre_defined_cards/1").to route_to("pre_defined_cards#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/pre_defined_cards/1/edit").to route_to("pre_defined_cards#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/pre_defined_cards").to route_to("pre_defined_cards#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/pre_defined_cards/1").to route_to("pre_defined_cards#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/pre_defined_cards/1").to route_to("pre_defined_cards#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/pre_defined_cards/1").to route_to("pre_defined_cards#destroy", :id => "1")
    end

  end
end
