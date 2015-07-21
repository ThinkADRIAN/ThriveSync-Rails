require 'rails_helper' 

describe MoodsController, :type => :controller do
  include Devise::TestHelpers

  describe "GET #index" do 
    context "with anonymous user" do
      before :each do
        # This simulates an anonymous user
        login_with nil
      end
      
      it "redirects to signin" do
        get :index
        expect( response ).to redirect_to( new_user_session_path )
      end
    end
    
    context "with authenticated user" do
      before :each do
        # This simulates an authenticated user
        @spec_user = FactoryGirl.create(:user)
        login_with @spec_user
        
        @spec_moods = FactoryGirl.create_list(:mood, 5, user: @spec_user)
      end

      context "with HTML request" do
        before :each do
          get :index
        end

        it "returns a successful 200 response" do
          expect(response).to be_success
        end
        
        it "populates an array of moods" do 
          expect(assigns(:moods).to_a).to eq(@spec_moods)
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

        it "returns all the moods" do
          parsed_response = JSON.parse(response.body)
          expect(parsed_response['moods'].length).to eq(5)
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
        expect( response ).to redirect_to( new_user_session_path )
      end
    end
    
    context "with authenticated user" do
      before :each do
        # This simulates an authenticated user
        @spec_user = FactoryGirl.create(:user)
        login_with @spec_user
      end

      context "with HTML request" do
        before :each do
          @spec_mood = FactoryGirl.create(:mood, user: @spec_user) 
          get :show, id: @spec_mood.id
        end
        
        it "assigns the requested mood to @mood" do
          expect(assigns(:mood)).to eq(@spec_mood)
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

        it "returns the requested mood" do
          parsed_response = JSON.parse(response.body)
          expect(parsed_response[:mood]).to eq(@spec_mood)
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
        expect( response ).to redirect_to( new_user_session_path )
      end
    end
    
    context "with authenticated user" do
      before :each do
        # This simulates an authenticated user
        @spec_user = FactoryGirl.create(:user)
        login_with @spec_user
      end

      context "with HTML request" do
        before :each do
          get :new 
        end
        
        it "assigns a new Mood to @mood" do
          expect(assigns(:mood)).to be_a_new(Mood)
        end
      end

      context "with JS request" do
        it "renders js output" do
          xhr :get, :new, @params
        end
      end

      context "with JSON request" do
        before :each do
          get :new, format: :json
        end

        it "returns a successful 200 response" do
          expect(response).to be_success
        end

        it "returns the requested mood" do
          parsed_response = JSON.parse(response.body)
          expect(parsed_response[:mood]).to eq(@spec_mood)
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
        expect( response ).to redirect_to( new_user_session_path )
      end
    end
    
    context "with authenticated user" do
      before :each do
        # This simulates an authenticated user
        @spec_user = FactoryGirl.create(:user)
        login_with @spec_user

        @spec_mood = FactoryGirl.create(:mood, user: @spec_user) 
      end

      context "with HTML request" do
        before :each do
          get :edit, id: @spec_mood.id, mood_rating: @spec_mood.mood_rating, anxiety_rating: @spec_mood.anxiety_rating, irritability_rating: @spec_mood.irritability_rating
        end
        it "assigns an existing Mood to @mood" do
          expect(assigns(:mood)).to eq(@spec_mood)
        end
      end

      context "with JS request" do
        it "renders js output" do
          xhr :get, :edit, id: @spec_mood.id, mood_rating: @spec_mood.mood_rating, anxiety_rating: @spec_mood.anxiety_rating, irritability_rating: @spec_mood.irritability_rating
        end
      end

      context "with JSON request" do
        before :each do
          get :edit, format: :json, id: @spec_mood.id, mood_rating: @spec_mood.mood_rating, anxiety_rating: @spec_mood.anxiety_rating, irritability_rating: @spec_mood.irritability_rating
        end

        it "returns a successful 200 response" do
          expect(response).to be_success
        end

        it "returns the requested mood" do
          parsed_response = JSON.parse(response.body)
          moods = parsed_response['mood']
          expect(moods["id"]).to eq(@spec_mood.id)
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
        expect( response ).to redirect_to( new_user_session_path )
      end
    end
    
    context "with authenticated user" do
      before :each do
        # This simulates an authenticated user
        @spec_user = FactoryGirl.create(:user)
        login_with @spec_user
      end

      before(:context) do
        @spec_mood_attrs = FactoryGirl.attributes_for(:mood, user: @spec_user).as_json
      end

      context "with valid JSON attributes(:context)" do 
        it "creates a new mood" do 
          expect{
            post :create, :mood_rating => @spec_mood_attrs["mood_rating"], :anxiety_rating => @spec_mood_attrs["anxiety_rating"], :irritability_rating => @spec_mood_attrs["irritability_rating"], format: :json

          }.to change(Mood,:count).by(1) 
        end

        it "returns a created 201 response" do 
          post :create, :mood_rating => @spec_mood_attrs["mood_rating"], :anxiety_rating => @spec_mood_attrs["anxiety_rating"], :irritability_rating => @spec_mood_attrs["irritability_rating"], format: :json
          expect(response).to have_http_status(:created)
          #expect(response).to redirect_to Mood.last 
        end 
      end 

      context "with invalid JSON attributes" do 
        it "does not save the new mood" do
          @spec_invalid_mood_attrs = FactoryGirl.attributes_for(:invalid_mood).as_json
          expect{ 
            post :create, :mood_rating => @spec_invalid_mood_attrs["mood_rating"], :anxiety_rating => @spec_invalid_mood_attrs["anxiety_rating"], :irritability_rating => @spec_invalid_mood_attrs["irritability_rating"], format: :json
          }.to_not change(Mood,:count) 
        end 

        it "re-renders JS for new method" do 
          @spec_invalid_mood_attrs = FactoryGirl.attributes_for(:invalid_mood).as_json
          post :create, :mood_rating => @spec_invalid_mood_attrs["mood_rating"], :anxiety_rating => @spec_invalid_mood_attrs["anxiety_rating"], :irritability_rating => @spec_invalid_mood_attrs["irritability_rating"], format: :json
          xhr :get, :new, @params
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
        expect( response ).to redirect_to( new_user_session_path )
      end
    end
    
    context "with authenticated user" do
      before :each do
        # This simulates an authenticated user
        @spec_user = FactoryGirl.create(:user)
        login_with @spec_user
      end

      before do
        @spec_mood_attrs = FactoryGirl.attributes_for(:mood, user: @spec_user).as_json
        @spec_updated_mood_attrs = FactoryGirl.attributes_for(:mood, user: @spec_user).as_json
        @spec_mood = FactoryGirl.create(:mood, @spec_mood_attrs)
      end

      context "with valid JSON attributes" do
        it "located the requested @mood" do
          put :update, :id => @spec_mood.as_json["id"], :mood_rating => @spec_mood_attrs["mood_rating"], :anxiety_rating => @spec_mood_attrs["anxiety_rating"], :irritability_rating => @spec_mood_attrs["irritability_rating"], format: :json
          expect(assigns(:mood).as_json).to eq(@spec_mood.as_json)
        end

        it "updates an existing mood using JSON" do 
          put :update, :id => @spec_mood.as_json["id"], :mood_rating => @spec_updated_mood_attrs["mood_rating"], :anxiety_rating => @spec_updated_mood_attrs["anxiety_rating"], :irritability_rating => @spec_updated_mood_attrs["irritability_rating"], format: :json

          @spec_mood.reload
          expect(@spec_mood.mood_rating).to eq(@spec_updated_mood_attrs["mood_rating"])
          expect(@spec_mood.anxiety_rating).to eq(@spec_updated_mood_attrs["anxiety_rating"])
          expect(@spec_mood.irritability_rating).to eq(@spec_updated_mood_attrs["irritability_rating"])
        end

        it "returns a created 201 response" do 
          put :update, :id => @spec_mood.as_json["id"], :mood_rating => @spec_updated_mood_attrs["mood_rating"], :anxiety_rating => @spec_updated_mood_attrs["anxiety_rating"], :irritability_rating => @spec_updated_mood_attrs["irritability_rating"], format: :json
          expect(response).to have_http_status(:created)
          #expect(response).to redirect_to Mood.last 
        end 

        it "gives a success flash message" do
          put :update, :id => @spec_mood.as_json["id"], :mood_rating => @spec_updated_mood_attrs["mood_rating"], :anxiety_rating => @spec_updated_mood_attrs["anxiety_rating"], :irritability_rating => @spec_updated_mood_attrs["irritability_rating"], format: :json
          expect(flash[:success]).to eq("Mood Entry was successfully updated.")
        end
      end 

      context "with invalid JSON attributes" do 
        it "does not update the new mood" do
          @spec_invalid_mood_attrs = FactoryGirl.attributes_for(:invalid_mood).as_json
          expect{ 
            put :update, :id => @spec_mood.as_json["id"], :mood_rating => @spec_invalid_mood_attrs["mood_rating"], :anxiety_rating => @spec_invalid_mood_attrs["anxiety_rating"], :irritability_rating => @spec_invalid_mood_attrs["irritability_rating"], format: :json
          }.to_not change(Mood,:count) 
        end 

        it "re-renders JS for edit method" do 
          @spec_invalid_mood_attrs = FactoryGirl.attributes_for(:invalid_mood).as_json
          put :update, :id => @spec_mood.as_json["id"], :mood_rating => @spec_invalid_mood_attrs["mood_rating"], :anxiety_rating => @spec_invalid_mood_attrs["anxiety_rating"], :irritability_rating => @spec_invalid_mood_attrs["irritability_rating"], format: :json
          get :edit, :id => @spec_mood.as_json["id"], :mood_rating => @spec_updated_mood_attrs["mood_rating"], :anxiety_rating => @spec_updated_mood_attrs["anxiety_rating"], :irritability_rating => @spec_updated_mood_attrs["irritability_rating"]
        end

        it "gives an error flash message" do
          @spec_invalid_mood_attrs = FactoryGirl.attributes_for(:invalid_mood).as_json
          put :update, :id => @spec_mood.as_json["id"], :mood_rating => @spec_invalid_mood_attrs["mood_rating"], :anxiety_rating => @spec_invalid_mood_attrs["anxiety_rating"], :irritability_rating => @spec_invalid_mood_attrs["irritability_rating"], format: :json
          expect(flash[:error]).to eq("Mood Entry was not updated... Try again???")
        end
      end 
    end
  end

  describe "GET #delete" do 
    it "assigns an existing Mood to @mood" 
    it "renders the :delete template" 
  end

  describe "DELETE #destroy" do 
    context "with anonymous user" do
      before :each do
        # This simulates an anonymous user
        login_with nil
      end
      
      it "redirects to signin" do
        get :edit, id: 1
        expect( response ).to redirect_to( new_user_session_path )
      end
    end

    context "with authenticated user" do
      before :each do
        # This simulates an authenticated user
        @spec_user = FactoryGirl.create(:user)
        login_with @spec_user
      end

      before :each do 
        @spec_mood_attrs = FactoryGirl.attributes_for(:mood, user: @spec_user).as_json
        @spec_mood = FactoryGirl.create(:mood, @spec_mood_attrs)
      end 

      context "with JS request" do
        it "deletes the mood" do 
          expect{ 
            delete :destroy, id: @spec_mood.as_json["id"], format: :js
          }.to change(Mood,:count).by(-1) 
        end 

        it "re-renders JS for index method" do 
          delete :destroy, id: @spec_mood.as_json["id"], format: :js
          xhr :get, :index, @params
        end

        it "gives a success flash message" do 
          delete :destroy, id: @spec_mood.as_json["id"], format: :js
          expect(flash[:success]).to eq("Mood Entry was successfully deleted.")
        end
      end

      context "with JSON request" do
        it "deletes the mood" do 
          expect{ 
            delete :destroy, id: @spec_mood.as_json["id"], format: :json
          }.to change(Mood,:count).by(-1) 
        end 

        it "returns a no content 204 response" do 
          delete :destroy, id: @spec_mood.as_json["id"], format: :json
          expect(response).to have_http_status(:no_content)
        end
      end
    end
  end

  describe "GET #cancel" do 
    it "assigns an existing Mood to @mood" 
    it "renders the :cancel template" 
  end
end