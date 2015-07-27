require 'rails_helper' 

describe SelfCaresController, :type => :controller do
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
        
        @spec_self_cares = FactoryGirl.create_list(:self_care, 5, user: @spec_user)
      end

      context "with HTML request" do
        before :each do
          get :index
        end

        it "returns a successful 200 response" do
          expect(response).to be_success
        end
        
        it "populates an array of self cares" do 
          expect(assigns(:self_cares).to_a).to eq(@spec_self_cares)
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

        it "returns all the self cares" do
          parsed_response = JSON.parse(response.body)
          expect(parsed_response['self_cares'].length).to eq(5)
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
          @spec_self_care = FactoryGirl.create(:self_care, user: @spec_user) 
          get :show, id: @spec_self_care.id
        end
        
        it "assigns the requested self care to @self_care" do
          expect(assigns(:self_care)).to eq(@spec_self_care)
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

        it "returns the requested self care" do
          parsed_response = JSON.parse(response.body)
          expect(parsed_response[:self_care]).to eq(@spec_self_care)
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
        
        it "assigns a new Self Care to @self_care" do
          expect(assigns(:self_care)).to be_a_new(SelfCare)
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

        it "returns the requested self care" do
          parsed_response = JSON.parse(response.body)
          expect(parsed_response[:self_care]).to eq(@spec_mood)
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

        @spec_self_care = FactoryGirl.create(:self_care, user: @spec_user) 
      end

      context "with HTML request" do
        before :each do
          get :edit, id: @spec_self_care.id, counseling: @spec_self_care.counseling, medication: @spec_self_care.medication, meditation: @spec_self_care.meditation, exercise: @spec_self_care.exercise
        end
        it "assigns an existing Self Care to @self_care" do
          expect(assigns(:self_care)).to eq(@spec_self_care)
        end
      end

      context "with JS request" do
        it "renders js output" do
          xhr :get, :edit, id: @spec_self_care.id, counseling: @spec_self_care.counseling, medication: @spec_self_care.medication, meditation: @spec_self_care.meditation, exercise: @spec_self_care.exercise
        end
      end

      context "with JSON request" do
        before :each do
          get :edit, format: :json, id: @spec_self_care.id, counseling: @spec_self_care.counseling, medication: @spec_self_care.medication, meditation: @spec_self_care.meditation, exercise: @spec_self_care.exercise
        end

        it "returns a successful 200 response" do
          expect(response).to be_success
        end

        it "returns the requested self care" do
          parsed_response = JSON.parse(response.body)
          self_cares = parsed_response['self_care']
          expect(self_cares["id"]).to eq(@spec_self_care.id)
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
        @spec_self_care_attrs = FactoryGirl.attributes_for(:self_care, user: @spec_user).as_json
      end

      context "with valid JS request(:context)" do 
        it "creates a new self care" do 
          expect{
            xhr :post, :create, :self_care => @spec_self_care_attrs
          }.to change(SelfCare,:count).by(1) 
        end

        it "returns a created 201 response" do 
         xhr :post, :create, :self_care => @spec_self_care_attrs
          expect(response).to have_http_status(:created)
          #expect(response).to redirect_to SelfCare.last 
        end 
      end 

      context "with valid JSON attributes(:context)" do 
        it "creates a new self care" do 
          expect{
            post :create, :self_care => @spec_self_care_attrs, format: :json
          }.to change(SelfCare,:count).by(1) 
        end

        it "returns a created 201 response" do 
          post :create, :self_care => @spec_self_care_attrs, format: :json
          expect(response).to have_http_status(:created)
          #expect(response).to redirect_to SelfCare.last 
        end 
      end 

      context "with invalid JS request" do 
        it "does not save the new self care" do
          @spec_invalid_self_care_attrs = FactoryGirl.attributes_for(:invalid_self_care).as_json
          expect{ 
            xhr :post, :create, self_care: @spec_invalid_self_care_attrs
          }.to_not change(SelfCare,:count) 
        end 

        it "re-renders JS for new method" do 
          @spec_invalid_self_care_attrs = FactoryGirl.attributes_for(:invalid_self_care).as_json
          xhr :post, :create, self_care: @spec_invalid_self_care_attrs
          xhr :get, :new, @params
        end 
      end

      context "with invalid JSON attributes" do 
        it "does not save the new self care" do
          @spec_invalid_self_care_attrs = FactoryGirl.attributes_for(:invalid_self_care).as_json
          expect{ 
            post :create, self_care: @spec_invalid_self_care_attrs, format: :json
          }.to_not change(SelfCare,:count) 
        end 

        it "re-renders JS for new method" do 
          @spec_invalid_self_care_attrs = FactoryGirl.attributes_for(:invalid_self_care).as_json
          xhr :post, :create, self_care: @spec_invalid_self_care_attrs
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
        @spec_self_care_attrs = FactoryGirl.attributes_for(:self_care, user: @spec_user).as_json
        @spec_updated_self_care_attrs = FactoryGirl.attributes_for(:self_care, user: @spec_user).as_json
        @spec_updated_self_care_timestamp = DateTime.now
        @spec_self_care = FactoryGirl.create(:self_care, @spec_self_care_attrs)
      end

      context "with valid JS request" do
        it "located the requested @self_care" do
          xhr :put, :update, :id => @spec_self_care.as_json["id"], self_care: @spec_self_care_attrs
          @spec_self_care.reload
          expect(assigns(:self_care).as_json).to eq(@spec_self_care.as_json)
        end

        it "updates an existing self care" do 
          xhr :put, :update, :id => @spec_self_care.as_json["id"], self_care: @spec_updated_self_care_attrs
          @spec_self_care.reload
          expect(@spec_self_care.counseling).to eq(@spec_updated_self_care_attrs["counseling"])
          expect(@spec_self_care.medication).to eq(@spec_updated_self_care_attrs["medication"])
          expect(@spec_self_care.meditation).to eq(@spec_updated_self_care_attrs["meditation"])
          expect(@spec_self_care.exercise).to eq(@spec_updated_self_care_attrs["exercise"])
        end

        it "returns a updated 200 response" do 
          xhr :put, :update, :id => @spec_self_care.as_json["id"], self_care: @spec_updated_self_care_attrs
          expect(response).to be_success
          #expect(response).to redirect_to SelfCare.last 
        end 

        it "gives a success flash message" do
          xhr :put, :update, :id => @spec_self_care.as_json["id"], self_care: @spec_updated_self_care_attrs
          expect(flash[:success]).to eq("Self Care Entry was successfully updated.")
        end
      end 

      context "with valid JSON attributes" do
        it "located the requested @self_care" do
          put :update, :id => @spec_self_care.as_json["id"], self_care: {:counseling => @spec_self_care_attrs["counseling"], :medication => @spec_self_care_attrs["medication"], :meditation => @spec_self_care_attrs["meditation"], :exercise => @spec_self_care_attrs["exercise"]}, format: :json
          expect(assigns(:self_care).as_json).to eq(@spec_self_care.as_json)
        end

        it "updates an existing self care" do 
          put :update, :id => @spec_self_care.as_json["id"], self_care: {:counseling => @spec_updated_self_care_attrs["counseling"], :medication => @spec_updated_self_care_attrs["medication"], :meditation => @spec_updated_self_care_attrs["meditation"], :exercise => @spec_updated_self_care_attrs["exercise"]}, format: :json

          @spec_self_care.reload
          expect(@spec_self_care.counseling).to eq(@spec_updated_self_care_attrs["counseling"])
          expect(@spec_self_care.medication).to eq(@spec_updated_self_care_attrs["medication"])
          expect(@spec_self_care.meditation).to eq(@spec_updated_self_care_attrs["meditation"])
          expect(@spec_self_care.exercise).to eq(@spec_updated_self_care_attrs["exercise"])
        end

        it "returns a created 200 response" do 
          put :update, :id => @spec_self_care.as_json["id"], self_care: {:counseling => @spec_updated_self_care_attrs["counseling"], :medication => @spec_updated_self_care_attrs["medication"], :meditation => @spec_updated_self_care_attrs["meditation"], :exercise => @spec_updated_self_care_attrs["exercise"]}, format: :json
          #expect(response).to redirect_to SelfCare.last 
        end 

        it "gives a success flash message" do
          put :update, :id => @spec_self_care.as_json["id"], self_care: {:counseling => @spec_updated_self_care_attrs["counseling"], :medication => @spec_updated_self_care_attrs["medication"], :meditation => @spec_updated_self_care_attrs["meditation"], :exercise => @spec_updated_self_care_attrs["exercise"]}, format: :json
          expect(flash[:success]).to eq("Self Care Entry was successfully updated.")
        end
      end 

      context "with invalid JSON attributes" do 
        it "does not update the new self care" do
          @spec_invalid_self_care_attrs = FactoryGirl.attributes_for(:invalid_self_care).as_json
          expect{ 
            put :update, :id => @spec_self_care.as_json["id"], self_care: {:counseling => @spec_invalid_self_care_attrs["counseling"], :medication => @spec_invalid_self_care_attrs["medication"], :meditation => @spec_invalid_self_care_attrs["meditation"], :exercise => @spec_invalid_self_care_attrs["exercise"]}, format: :json
          }.to_not change(SelfCare,:count) 
        end 

        it "re-renders JS for edit method" do 
          @spec_invalid_self_care_attrs = FactoryGirl.attributes_for(:invalid_self_care).as_json
          put :update, :id => @spec_self_care.as_json["id"], self_care: {:counseling => @spec_invalid_self_care_attrs["counseling"], :medication => @spec_invalid_self_care_attrs["medication"], :meditation => @spec_invalid_self_care_attrs["meditation"], :exercise => @spec_invalid_self_care_attrs["exercise"]}, format: :js
          xhr :get, :edit, :id => @spec_self_care.as_json["id"], self_care: {:counseling => @spec_updated_self_care_attrs["counseling"], :medication => @spec_updated_self_care_attrs["medication"], :meditation => @spec_updated_self_care_attrs["meditation"], :exercise => @spec_updated_self_care_attrs["exercise"]}, format: :json
        end

        it "gives an error flash message" do
          @spec_invalid_self_care_attrs = FactoryGirl.attributes_for(:invalid_self_care).as_json
          put :update, :id => @spec_self_care.as_json["id"], self_care: {:counseling => @spec_invalid_self_care_attrs["counseling"], :medication => @spec_invalid_self_care_attrs["medication"], :meditation => @spec_invalid_self_care_attrs["meditation"], :exercise => @spec_invalid_self_care_attrs["exercise"]}, format: :json
          expect(flash[:error]).to eq("Self Care Entry was not updated... Try again???")
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
        @spec_self_care_attrs = FactoryGirl.attributes_for(:self_care, user: @spec_user).as_json
        @spec_self_care = FactoryGirl.create(:self_care, @spec_self_care_attrs)
      end

      context "with JS request" do
        it "re-renders JS for index method" do 
          xhr :get, :delete, self_care_id: @spec_self_care.as_json["id"], format: :js
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
        get :delete, self_care_id: 1
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
        @spec_self_care_attrs = FactoryGirl.attributes_for(:self_care, user: @spec_user).as_json
        @spec_self_care = FactoryGirl.create(:self_care, @spec_self_care_attrs)
      end 

      context "with JS request" do
        it "deletes the self care" do 
          expect{ 
            delete :destroy, id: @spec_self_care.as_json["id"], format: :js
          }.to change(SelfCare,:count).by(-1) 
        end 

        it "re-renders JS for index method" do 
          delete :destroy, id: @spec_self_care.as_json["id"], format: :js
          xhr :get, :index, @params
        end

        it "gives a success flash message" do 
          delete :destroy, id: @spec_self_care.as_json["id"], format: :js
          expect(flash[:success]).to eq("Self Care Entry was successfully deleted.")
        end
      end

      context "with JSON request" do
        it "deletes the self care" do 
          expect{ 
            delete :destroy, id: @spec_self_care.as_json["id"], format: :json
          }.to change(SelfCare,:count).by(-1) 
        end 

        it "returns a no content 204 response" do 
          delete :destroy, id: @spec_self_care.as_json["id"], format: :json
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