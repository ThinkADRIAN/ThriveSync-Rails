require 'rails_helper'

describe PreDefinedCardsController, type: :controller do
  include Devise::TestHelpers

  describe "GET #index" do
    context "with anonymous user" do
      before :each do
        # This simulates an anonymous user
        login_with nil
      end

      it "redirects to signin" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "with authenticated user" do
      before :each do
        # This simulates an authenticated user
        login_user
      end

      it "redirects to root" do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end

    context "with authenticated superuser" do
      before :each do
        # This simulates an authenticated superuser
        @spec_user = login_super_user

        @spec_pre_defined_cards = FactoryGirl.create_list(:pre_defined_card, 5)
      end

      context "with HTML request" do
        before :each do
          get :index
        end

        it "returns a successful 200 response" do
          expect(response).to be_success
        end

        it "populates an array of pre_defined_cards" do
          expect(assigns(:pre_defined_cards).to_a).to eq(@spec_pre_defined_cards)
        end

        it "renders the :index view" do
          expect(response).to render_template :index
        end
      end

      context "with JS request" do
        it "renders js output" do
          xhr :get, :index, @params
        end
      end

      context "with JSON request" do
        before :each do
          get :index, format: :json
        end

        it "returns a successful 200 response" do
          expect(response).to be_success
        end

        it "returns all the pre_defined_cards" do
          parsed_response = JSON.parse(response.body)
          expect(parsed_response['pre_defined_cards'].length).to eq(5)
        end
      end
    end
  end

  describe "GET #show" do
    context "with anonymous user" do
      before :each do
        # This simulates an anonymous user
        login_with nil
      end

      it "redirects to signin" do
        get :show, id: 1
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "with authenticated user" do
      before :each do
        # This simulates an authenticated user
        login_user

        @spec_pre_defined_card = FactoryGirl.create(:pre_defined_card)
      end

      it "redirects to root" do
        get :show, id: @spec_pre_defined_card.id
        expect(response).to redirect_to(root_path)
      end
    end

    context "with authenticated superuser" do
      before :each do
        # This simulates an authenticated superuser
        login_super_user
      end

      context "with HTML request" do
        before :each do
          @spec_pre_defined_card = FactoryGirl.create(:pre_defined_card)
          get :show, id: @spec_pre_defined_card.id
        end

        it "assigns the requested pre_defined_card to @pre_defined_card" do
          expect(assigns(:pre_defined_card)).to eq(@spec_pre_defined_card)
        end
      end

      context "with JSON request" do
        before :each do
          get :index, format: :json
        end

        it "returns a successful 200 response" do
          expect(response).to be_success
        end

        it "returns the requested pre_defined_card" do
          parsed_response = JSON.parse(response.body)
          expect(parsed_response[:pre_defined_card]).to eq(@spec_pre_defined_card)
        end
      end
    end
  end

  describe "GET #new" do
    context "with anonymous user" do
      before :each do
        # This simulates an anonymous user
        login_with nil
      end

      it "redirects to signin" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "with authenticated user" do
      before :each do
        # This simulates an authenticated user
        login_user
      end

      it "redirects to root" do
        get :new
        expect(response).to redirect_to(root_path)
      end
    end

    context "with authenticated superuser" do
      before :each do
        # This simulates an authenticated superuser
        login_super_user
      end

      context "with HTML request" do
        before :each do
          get :new
        end

        it "assigns a new Pre-Defined Card to @pre_defined_card)" do
          expect(assigns(:pre_defined_card)).to be_a_new(PreDefinedCard)
        end
      end

      context "with JSON request" do
        before :each do
          get :new, format: :json
        end

        it "returns a successful 200 response" do
          expect(response).to be_success
        end

        it "returns the requested pre_defined_card" do
          parsed_response = JSON.parse(response.body)
          expect(parsed_response[:pre_defined_card]).to eq(@spec_pre_defined_card)
        end
      end
    end
  end

  describe "GET #edit" do
    context "with anonymous user" do
      before :each do
        # This simulates an anonymous user
        login_with nil
      end

      it "redirects to signin" do
        get :edit, id: 1
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "with authenticated user" do
      before :each do
        # This simulates an authenticated user
        login_user

        @spec_pre_defined_card = FactoryGirl.create(:pre_defined_card)
      end

      it "redirects to root" do
        get :edit, id: @spec_pre_defined_card.id, text: @spec_pre_defined_card.text, category: @spec_pre_defined_card.category
        expect(response).to redirect_to(root_path)
      end
    end

    context "with authenticated user" do
      before :each do
        # This simulates an authenticated superuser
        login_super_user

        @spec_pre_defined_card = FactoryGirl.create(:pre_defined_card)
      end

      context "with HTML request" do
        before :each do
          get :edit, id: @spec_pre_defined_card.id, text: @spec_pre_defined_card.text, category: @spec_pre_defined_card.category
        end
        it "assigns an existing PreDefinedCard to @pre_defined_card" do
          expect(assigns(:pre_defined_card)).to eq(@spec_pre_defined_card)
        end
      end

      context "with JSON request" do
        before :each do
          get :edit, format: :json, id: @spec_pre_defined_card.id, text: @spec_pre_defined_card.text
        end

        it "returns a successful 200 response" do
          expect(response).to be_success
        end

        it "returns the requested pre_defined_card" do
          parsed_response = JSON.parse(response.body)
          pre_defined_cards = parsed_response['pre_defined_card']
          expect(pre_defined_cards["id"]).to eq(@spec_pre_defined_card.id)
        end
      end
    end
  end

  describe "POST #create" do
    context "with anonymous user" do
      before :each do
        # This simulates an anonymous user
        login_with nil
      end

      it "redirects to signin" do
        post :create
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "with authenticated user" do
      before :each do
        # This simulates an authenticated user
        login_user

        @spec_pre_defined_card = FactoryGirl.create(:pre_defined_card)
      end

      it "redirects to root" do
        post :create
        expect(response).to redirect_to(root_path)
      end
    end

    context "with authenticated superuser" do
      before :each do
        # This simulates an authenticated superuser
        login_super_user
      end

      before(:context) do
        @spec_pre_defined_card_attrs = FactoryGirl.attributes_for(:pre_defined_card).as_json
      end

      context "with valid JSON attributes(:context)" do
        it "creates a new pre_defined_card" do
          expect {
            post :create, :pre_defined_card => @spec_pre_defined_card_attrs, format: :json
          }.to change(PreDefinedCard, :count).by(1)
        end

        it "returns a created 201 response" do
          post :create, :pre_defined_card => @spec_pre_defined_card_attrs, format: :json
          expect(response).to have_http_status(:created)
        end
      end
    end
  end

  describe "PATCH/PUT #update" do
    context "with anonymous user" do
      before :each do
        # This simulates an anonymous user
        login_with nil
      end

      it "redirects to signin" do
        put :update, id: 1
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "with authenticated user" do
      before :each do
        # This simulates an authenticated user
        login_user

        @spec_pre_defined_card = FactoryGirl.create(:pre_defined_card)
      end

      it "redirects to root" do
        put :update, id: @spec_pre_defined_card.id
        expect(response).to redirect_to(root_path)
      end
    end

    context "with authenticated superuser" do
      before :each do
        # This simulates an authenticated superuser
        login_super_user
      end

      before do
        @spec_pre_defined_card_attrs = FactoryGirl.attributes_for(:pre_defined_card).as_json
        @spec_updated_pre_defined_card_attrs = FactoryGirl.attributes_for(:pre_defined_card).as_json
        @spec_pre_defined_card = FactoryGirl.create(:pre_defined_card, @spec_pre_defined_card_attrs)
      end

      context "with valid JSON attributes" do
        it "located the requested @pre_defined_card" do
          put :update, :id => @spec_pre_defined_card.as_json["id"], pre_defined_card: {:text => @spec_updated_pre_defined_card_attrs["text"], :category => @spec_updated_pre_defined_card_attrs["category"]}, format: :json
          @spec_pre_defined_card.reload
          expect(assigns(:pre_defined_card).as_json).to eq(@spec_pre_defined_card.as_json)
        end

        it "updates an existing pre_defined_card" do
          put :update, :id => @spec_pre_defined_card.as_json["id"], pre_defined_card: {:text => @spec_updated_pre_defined_card_attrs["text"], :category => @spec_updated_pre_defined_card_attrs["category"]}, format: :json
          @spec_pre_defined_card.reload
          expect(@spec_pre_defined_card.text).to eq(@spec_updated_pre_defined_card_attrs["text"])
          expect(@spec_pre_defined_card.category).to eq(@spec_updated_pre_defined_card_attrs["category"])
        end

        it "returns a created 200 response" do
          put :update, :id => @spec_pre_defined_card.as_json["id"], pre_defined_card: {:text => @spec_updated_pre_defined_card_attrs["text"], :category => @spec_updated_pre_defined_card_attrs["category"]}, format: :json
          expect(response).to be_success
        end

        it "gives a success flash message" do
          put :update, :id => @spec_pre_defined_card.as_json["id"], pre_defined_card: {:text => @spec_updated_pre_defined_card_attrs["text"], :category => @spec_updated_pre_defined_card_attrs["category"]}, format: :json
          expect(flash[:success]).to eq("Pre-Defined Card was successfully updated.")
        end
      end
    end
  end

  describe "DELETE #destroy" do
    context "with anonymous user" do
      before :each do
        # This simulates an anonymous user
        login_with nil
      end

      it "redirects to signin" do
        delete :destroy, id: 1
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "with authenticated user" do
      before :each do
        # This simulates an authenticated user
        login_user

        @spec_pre_defined_card = FactoryGirl.create(:pre_defined_card)
      end

      it "redirects to root" do
        delete :destroy, id: @spec_pre_defined_card.id
        expect(response).to redirect_to(root_path)
      end
    end

    context "with authenticated user" do
      before :each do
        # This simulates an authenticated superuser
        login_super_user
      end

      before :each do
        @spec_updated_pre_defined_card_attrs = FactoryGirl.attributes_for(:pre_defined_card).as_json
        @spec_pre_defined_card = FactoryGirl.create(:pre_defined_card, @spec_pre_defined_card_attrs)
      end

      context "with JSON request" do
        it "deletes the pre_defined_card" do
          expect {
            delete :destroy, id: @spec_pre_defined_card.as_json["id"], format: :json
          }.to change(PreDefinedCard, :count).by(-1)
        end

        it "returns a no content 204 response" do
          delete :destroy, id: @spec_pre_defined_card.as_json["id"], format: :json
          expect(response).to have_http_status(:no_content)
        end
      end
    end
  end
end
