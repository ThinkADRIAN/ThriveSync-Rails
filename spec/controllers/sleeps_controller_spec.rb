require 'rails_helper' 

describe SleepsController, :type => :controller do
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
        
        @spec_sleeps = FactoryGirl.create_list(:sleep, 5, user: @spec_user)
      end

      context "with HTML request" do
        before :each do
          get :index
        end

        it "returns a successful 200 response" do
          expect(response).to be_success
        end
        
        it "populates an array of moods" do 
          expect(assigns(:sleeps).to_a).to eq(@spec_sleeps)
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

        it "returns all the sleeps" do
          parsed_response = JSON.parse(response.body)
          expect(parsed_response['sleeps'].length).to eq(5)
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
          @spec_sleep = FactoryGirl.create(:sleep, user: @spec_user) 
          get :show, id: @spec_sleep.id
        end
        
        it "assigns the requested mood to @sleep" do
          expect(assigns(:sleep)).to eq(@spec_sleep)
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

        it "returns the requested sleep" do
          parsed_response = JSON.parse(response.body)
          expect(parsed_response[:sleep]).to eq(@spec_mood)
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
        
        it "assigns a new Sleep to @sleep" do
          expect(assigns(:sleep)).to be_a_new(Sleep)
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

        it "returns the requested sleep" do
          parsed_response = JSON.parse(response.body)
          expect(parsed_response[:sleep]).to eq(@spec_sleep)
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

        @spec_sleep = FactoryGirl.create(:sleep, user: @spec_user) 
      end

      context "with HTML request" do
        before :each do
          get :edit, id: @spec_sleep.id, start_time: @spec_sleep.start_time, finish_time: @spec_sleep.finish_time, quality: @spec_sleep.quality
        end
        it "assigns an existing Sleep to @sleep" do
          expect(assigns(:sleep)).to eq(@spec_sleep)
        end
      end

      context "with JS request" do
        it "renders js output" do
          xhr :get, :edit, id: @spec_sleep.id, start_time: @spec_sleep.start_time, finish_time: @spec_sleep.finish_time, quality: @spec_sleep.quality
        end
      end

      context "with JSON request" do
        before :each do
          get :edit, format: :json, id: @spec_sleep.id, start_time: @spec_sleep.start_time, finish_time: @spec_sleep.finish_time, quality: @spec_sleep.quality
        end

        it "returns a successful 200 response" do
          expect(response).to be_success
        end

        it "returns the requested sleep" do
          parsed_response = JSON.parse(response.body)
          sleeps = parsed_response['sleep']
          expect(sleeps["id"]).to eq(@spec_sleep.id)
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
        @spec_sleep_attrs = FactoryGirl.attributes_for(:sleep, user: @spec_user).as_json
      end

      context "with valid JS request(:context)" do 
        it "creates a new sleep" do 
          expect{
            post :create, :start_time => @spec_sleep_attrs["start_time"], :finish_time => @spec_sleep_attrs["finish_time"], :quality => @spec_sleep_attrs["quality"], format: :js

          }.to change(Sleep,:count).by(1) 
        end

        it "returns a created 201 response" do 
          post :create, :start_time => @spec_sleep_attrs["start_time"], :finish_time => @spec_sleep_attrs["finish_time"], :quality => @spec_sleep_attrs["quality"], format: :js
          expect(response).to have_http_status(:created)
          #expect(response).to redirect_to Sleep.last 
        end 
      end 

      context "with valid JSON attributes(:context)" do 
        it "creates a new sleep" do 
          expect{
            post :create, :start_time => @spec_sleep_attrs["start_time"], :finish_time => @spec_sleep_attrs["finish_time"], :quality => @spec_sleep_attrs["quality"], format: :json

          }.to change(Sleep,:count).by(1) 
        end

        it "returns a created 201 response" do 
          post :create, :start_time => @spec_sleep_attrs["start_time"], :finish_time => @spec_sleep_attrs["finish_time"], :quality => @spec_sleep_attrs["quality"], format: :json
          expect(response).to have_http_status(:created)
          #expect(response).to redirect_to SelfCare.last 
        end 
      end 

      context "with invalid JS request" do 
        it "does not save the new mood" do
          @spec_invalid_sleep_attrs = FactoryGirl.attributes_for(:invalid_sleep).as_json
          expect{ 
            post :create, :start_time => @spec_invalid_sleep_attrs["start_time"], :finish_time => @spec_invalid_sleep_attrs["finish_time"], :quality => @spec_invalid_sleep_attrs["quality"], format: :js
          }.to_not change(Sleep,:count) 
        end 

        it "re-renders JS for new method" do 
          @spec_invalid_sleep_attrs = FactoryGirl.attributes_for(:invalid_sleep).as_json
          xhr :post, :create, :start_time => @spec_invalid_sleep_attrs["start_time"], :finish_time => @spec_invalid_sleep_attrs["finish_time"], :quality => @spec_invalid_sleep_attrs["quality"], format: :js
          xhr :get, :new, @params
        end 
      end

      context "with invalid JSON attributes" do 
        it "does not save the new mood" do
          @spec_invalid_sleep_attrs = FactoryGirl.attributes_for(:invalid_sleep).as_json
          expect{ 
            post :create, :start_time => @spec_invalid_sleep_attrs["start_time"], :finish_time => @spec_invalid_sleep_attrs["finish_time"], :quality => @spec_invalid_sleep_attrs["quality"], format: :json
          }.to_not change(Sleep,:count) 
        end 

        it "re-renders JS for new method" do 
          @spec_invalid_sleep_attrs = FactoryGirl.attributes_for(:invalid_sleep).as_json
          xhr :post, :create, :start_time => @spec_invalid_sleep_attrs["start_time"], :finish_time => @spec_invalid_sleep_attrs["finish_time"], :quality => @spec_invalid_sleep_attrs["quality"], format: :json
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
        @spec_sleep_attrs = FactoryGirl.attributes_for(:sleep, user: @spec_user).as_json
        @spec_updated_sleep_attrs = FactoryGirl.attributes_for(:sleep, user: @spec_user).as_json
        @spec_sleep = FactoryGirl.create(:sleep, @spec_sleep_attrs)
      end

      context "with valid JS request" do
        it "located the requested @sleep" do
          put :update, :id => @spec_sleep.as_json["id"], :start_time => @spec_sleep_attrs["start_time"], :finish_time => @spec_sleep_attrs["finish_time"], :quality => @spec_sleep_attrs["quality"], format: :js
          expect(assigns(:sleep).as_json).to eq(@spec_sleep.as_json)
        end

        it "updates an existing sleep" do 
          put :update, :id => @spec_sleep.as_json["id"], :start_time => @spec_updated_sleep_attrs["start_time"], :finish_time => @spec_updated_sleep_attrs["finish_time"], :quality => @spec_updated_sleep_attrs["quality"], format: :js

          @spec_sleep.reload
          expect(@spec_sleep.start_time).to eq(@spec_updated_sleep_attrs["start_time"])
          expect(@spec_sleep.finish_time).to eq(@spec_updated_sleep_attrs["finish_time"])
          expect(@spec_sleep.quality).to eq(@spec_updated_sleep_attrs["quality"])
          expect(@spec_sleep.time).to eq(@spec_updated_sleep_attrs["time"])
        end

        it "returns a updated 200 response" do 
          put :update, :id => @spec_sleep.as_json["id"], :start_time => @spec_updated_sleep_attrs["start_time"], :finish_time => @spec_updated_sleep_attrs["finish_time"], :quality => @spec_updated_sleep_attrs["quality"], format: :js
          expect(response).to be_success
          #expect(response).to redirect_to SelfCare.last 
        end 

        it "gives a success flash message" do
          put :update, :id => @spec_sleep.as_json["id"], :start_time => @spec_updated_sleep_attrs["start_time"], :finish_time => @spec_updated_sleep_attrs["finish_time"], :quality => @spec_updated_sleep_attrs["quality"], format: :js
          expect(flash[:success]).to eq("Sleep Entry was successfully updated.")
        end
      end 

      context "with valid JSON attributes" do
        it "located the requested @sleep" do
          put :update, :id => @spec_sleep.as_json["id"], :start_time => @spec_sleep_attrs["start_time"], :finish_time => @spec_sleep_attrs["finish_time"], :quality => @spec_sleep_attrs["quality"], format: :json
          expect(assigns(:sleep).as_json).to eq(@spec_sleep.as_json)
        end

        it "updates an existing sleep" do 
          put :update, :id => @spec_sleep.as_json["id"], :start_time => @spec_updated_sleep_attrs["start_time"], :finish_time => @spec_updated_sleep_attrs["finish_time"], :quality => @spec_updated_sleep_attrs["quality"], format: :json

          @spec_sleep.reload
          expect(@spec_sleep.start_time).to eq(@spec_updated_sleep_attrs["start_time"])
          expect(@spec_sleep.finish_time).to eq(@spec_updated_sleep_attrs["finish_time"])
          expect(@spec_sleep.quality).to eq(@spec_updated_sleep_attrs["quality"])
          expect(@spec_sleep.time).to eq(@spec_updated_sleep_attrs["time"])
        end

        it "returns a created 200 response" do 
          put :update, :id => @spec_sleep.as_json["id"], :start_time => @spec_updated_sleep_attrs["start_time"], :finish_time => @spec_updated_sleep_attrs["finish_time"], :quality => @spec_updated_sleep_attrs["quality"], format: :json
          expect(response).to be_success
          #expect(response).to redirect_to SelfCare.last 
        end 

        it "gives a success flash message" do
          put :update, :id => @spec_sleep.as_json["id"], :start_time => @spec_updated_sleep_attrs["start_time"], :finish_time => @spec_updated_sleep_attrs["finish_time"], :quality => @spec_updated_sleep_attrs["quality"], format: :json
          expect(flash[:success]).to eq("Sleep Entry was successfully updated.")
        end
      end 

      context "with invalid JSON attributes" do 
        it "does not update the new sleep" do
          @spec_invalid_sleep_attrs = FactoryGirl.attributes_for(:invalid_sleep).as_json
          expect{ 
            put :update, :id => @spec_sleep.as_json["id"], :start_time => @spec_invalid_sleep_attrs["start_time"], :finish_time => @spec_invalid_sleep_attrs["finish_time"], :quality => @spec_invalid_sleep_attrs["quality"], format: :json
          }.to_not change(Sleep,:count) 
        end 

        it "re-renders JS for edit method" do 
          @spec_invalid_sleep_attrs = FactoryGirl.attributes_for(:invalid_sleep).as_json
          put :update, :id => @spec_sleep.as_json["id"], :start_time => @spec_invalid_sleep_attrs["start_time"], :finish_time => @spec_invalid_sleep_attrs["finish_time"], :quality => @spec_invalid_sleep_attrs["quality"], format: :json
          xhr :get, :edit, :id => @spec_sleep.as_json["id"], :start_time => @spec_invalid_sleep_attrs["start_time"], :finish_time => @spec_invalid_sleep_attrs["finish_time"], :quality => @spec_invalid_sleep_attrs["quality"], format: :json
        end

        it "gives an error flash message" do
          @spec_invalid_sleep_attrs = FactoryGirl.attributes_for(:invalid_sleep).as_json
          put :update, :id => @spec_sleep.as_json["id"], :start_time => @spec_invalid_sleep_attrs["start_time"], :finish_time => @spec_invalid_sleep_attrs["finish_time"], :quality => @spec_invalid_sleep_attrs["quality"], format: :json
          expect(flash[:error]).to eq("Sleep Entry was not updated... Try again???")
        end
      end 
    end
  end

  describe "GET #delete" do
    context "with anonymous user" do
      before :each do
        # This simulates an anonymous user
        login_with nil
      end
      
      it "redirects to signin" do
        get :cancel
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
        @spec_sleep_attrs = FactoryGirl.attributes_for(:sleep, user: @spec_user).as_json
        @spec_sleep = FactoryGirl.create(:sleep, @spec_sleep_attrs)
      end

      context "with JS request" do
        it "re-renders JS for index method" do 
          xhr :get, :delete, sleep_id: @spec_sleep.as_json["id"], format: :js
          xhr :get, :index
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
        get :delete, sleep_id: 1
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
        @spec_sleep_attrs = FactoryGirl.attributes_for(:sleep, user: @spec_user).as_json
        @spec_sleep = FactoryGirl.create(:sleep, @spec_sleep_attrs)
      end 

      context "with JS request" do
        it "deletes the sleep" do 
          expect{ 
            delete :destroy, id: @spec_sleep.as_json["id"], format: :js
          }.to change(Sleep,:count).by(-1) 
        end 

        it "re-renders JS for index method" do 
          delete :destroy, id: @spec_sleep.as_json["id"], format: :js
          xhr :get, :index, @params
        end

        it "gives a success flash message" do 
          delete :destroy, id: @spec_sleep.as_json["id"], format: :js
          expect(flash[:success]).to eq("Sleep Entry was successfully deleted.")
        end
      end

      context "with JSON request" do
        it "deletes the sleep" do 
          expect{ 
            delete :destroy, id: @spec_sleep.as_json["id"], format: :json
          }.to change(Sleep,:count).by(-1) 
        end 

        it "returns a no content 204 response" do 
          delete :destroy, id: @spec_sleep.as_json["id"], format: :json
          expect(response).to have_http_status(:no_content)
        end
      end
    end
  end

  describe "GET #cancel" do 
    context "with anonymous user" do
      before :each do
        # This simulates an anonymous user
        login_with nil
      end
      
      it "redirects to signin" do
        get :cancel
        expect( response ).to redirect_to( new_user_session_path )
      end
    end

    context "with authenticated user" do
      before :each do
        # This simulates an authenticated user
        @spec_user = FactoryGirl.create(:user)
        login_with @spec_user
      end

      context "with JS request" do
        it "re-renders JS for index method" do 
          xhr :get, :cancel, format: :js
          xhr :get, :index
        end
      end
    end
  end
end