require 'rails_helper' 

describe JournalsController, :type => :controller do
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
        
        @spec_journals = FactoryGirl.create_list(:journal, 5, user: @spec_user)
      end

      context "with HTML request" do
        before :each do
          get :index
        end

        it "returns a successful 200 response" do
          expect(response).to be_success
        end
        
        it "populates an array of journals" do 
          expect(assigns(:journals).to_a).to eq(@spec_journals)
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

        it "returns all the journals" do
          parsed_response = JSON.parse(response.body)
          expect(parsed_response['journals'].length).to eq(5)
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
          @spec_journal = FactoryGirl.create(:journal, user: @spec_user) 
          get :show, id: @spec_journal.id
        end
        
        it "assigns the requested journal to @journal" do
          expect(assigns(:journal)).to eq(@spec_journal)
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

        it "returns the requested journal" do
          parsed_response = JSON.parse(response.body)
          expect(parsed_response[:journal]).to eq(@spec_journal)
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
        
        it "assigns a new Journal to @journal" do
          expect(assigns(:journal)).to be_a_new(Journal)
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

        it "returns the requested journal" do
          parsed_response = JSON.parse(response.body)
          expect(parsed_response[:journal]).to eq(@spec_journal)
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

        @spec_journal = FactoryGirl.create(:journal, user: @spec_user) 
      end

      context "with HTML request" do
        before :each do
          get :edit, id: @spec_journal.id, journal_entry: @spec_journal.journal_entry
        end
        it "assigns an existing Journal to @journal" do
          expect(assigns(:journal)).to eq(@spec_journal)
        end
      end

      context "with JS request" do
        it "renders js output" do
          xhr :get, :edit, id: @spec_journal.id, journal_entry: @spec_journal.journal_entry
        end
      end

      context "with JSON request" do
        before :each do
          get :edit, format: :json, id: @spec_journal.id, journal_entry: @spec_journal.journal_entry
        end

        it "returns a successful 200 response" do
          expect(response).to be_success
        end

        it "returns the requested journal" do
          parsed_response = JSON.parse(response.body)
          journals = parsed_response['journal']
          expect(journals["id"]).to eq(@spec_journal.id)
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
        @spec_journal_attrs = FactoryGirl.attributes_for(:journal, user: @spec_user).as_json
      end

      context "with valid JS request(:context)" do 
        it "creates a new journal" do 
          expect{
            xhr :post, :create, :journal => @spec_journal_attrs
          }.to change(Journal,:count).by(1) 
        end

        it "returns a created 201 response" do 
          xhr :post, :create, :journal => @spec_journal_attrs
          expect(response).to have_http_status(:created)
          #expect(response).to redirect_to Journal.last 
        end 
      end 

      context "with valid JSON attributes(:context)" do 
        it "creates a new journal" do 
          expect{
            post :create, :journal => @spec_journal_attrs, format: :json
          }.to change(Journal,:count).by(1) 
        end

        it "returns a created 201 response" do 
          post :create, :journal => @spec_journal_attrs, format: :json
          expect(response).to have_http_status(:created)
          #expect(response).to redirect_to Journal.last 
        end 
      end 
=begin
      context "with invalid JS request" do 
        it "does not save the new journal" do
          @spec_invalid_journal_attrs = FactoryGirl.attributes_for(:invalid_journal).as_json
          expect{ 
            xhr :post, :create, journal: @spec_invalid_journal_attrs
          }.to_not change(Journal,:count) 
        end 

        it "re-renders JS for new method" do 
          @spec_invalid_journal_attrs = FactoryGirl.attributes_for(:invalid_journal).as_json
          xhr :post, :create, journal: @spec_invalid_journal_attrs
          xhr :get, :new, @params
        end 
      end

      context "with invalid JSON attributes" do 
        it "does not save the new journal" do
          @spec_invalid_journal_attrs = FactoryGirl.attributes_for(:invalid_journal).as_json
          expect{ 
            post :create, journal: @spec_invalid_journal_attrs, format: :json
          }.to_not change(Journal,:count) 
        end 

        it "re-renders JS for new method" do 
          @spec_invalid_journal_attrs = FactoryGirl.attributes_for(:invalid_journal).as_json
          xhr :post, :create, journal: @spec_invalid_journal_attrs, format: :json
          xhr :get, :new, @params
        end 
      end
=end
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
        @spec_journal_attrs = FactoryGirl.attributes_for(:journal, user: @spec_user).as_json
        @spec_updated_journal_attrs = FactoryGirl.attributes_for(:journal, user: @spec_user).as_json
        @spec_updated_journal_timestamp = DateTime.now
        @spec_journal = FactoryGirl.create(:journal, @spec_journal_attrs)
      end

      context "with valid JS request" do
        it "located the requested @journal" do
          xhr :put, :update, :id => @spec_journal["id"], journal: @spec_journal_attrs
          @spec_journal.reload
          expect(assigns(:journal)).to eq(@spec_journal)
        end

        it "updates an existing journal" do 
          xhr :put, :update, :id => @spec_journal.as_json["id"], journal: @spec_updated_journal_attrs
          @spec_journal.reload
          expect(@spec_journal.journal_entry).to eq(@spec_updated_journal_attrs["journal_entry"])
        end

        it "returns a updated 200 response" do 
          xhr :put, :update, :id => @spec_journal.as_json["id"], journal: @spec_updated_journal_attrs
          expect(response).to be_success
          #expect(response).to redirect_to Journal.last 
        end 

        it "gives a success flash message" do
          xhr :put, :update, :id => @spec_journal.as_json["id"], journal: @spec_updated_journal_attrs
          expect(flash[:success]).to eq("Journal Entry was successfully updated.")
        end
      end 

      context "with valid JSON attributes" do
        it "located the requested @journal" do
          put :update, :id => @spec_journal.as_json["id"], journal: {:journal_entry => @spec_updated_journal_attrs["journal_entry"]}, format: :json
          @spec_journal.reload
          expect(assigns(:journal).as_json).to eq(@spec_journal.as_json)
        end

        it "updates an existing journal" do 
          put :update, :id => @spec_journal.as_json["id"], journal: {:journal_entry => @spec_updated_journal_attrs["journal_entry"]}, format: :json
          @spec_journal.reload
          expect(@spec_journal.journal_entry).to eq(@spec_updated_journal_attrs["journal_entry"])
        end

        it "returns a created 200 response" do 
          put :update, :id => @spec_journal.as_json["id"], journal: {:journal_entry => @spec_updated_journal_attrs["journal_entry"]}, format: :json
          expect(response).to be_success
          #expect(response).to redirect_to Journal.last 
        end 

        it "gives a success flash message" do
          put :update, :id => @spec_journal.as_json["id"], journal: {:journal_entry => @spec_updated_journal_attrs["journal_entry"]}, format: :json
          expect(flash[:success]).to eq("Journal Entry was successfully updated.")
        end
      end 
=begin
      context "with invalid JSON attributes" do 
        it "does not update the new mood" do
          @spec_invalid_mood_attrs = FactoryGirl.attributes_for(:invalid_mood).as_json
          expect{ 
            put :update, :id => @spec_mood.as_json["id"], :mood_rating => @spec_invalid_mood_attrs["mood_rating"], :anxiety_rating => @spec_invalid_mood_attrs["anxiety_rating"], :irritability_rating => @spec_invalid_mood_attrs["irritability_rating"], format: :json
          }.to_not change(Journal,:count) 
        end 

        it "re-renders JS for edit method" do 
          @spec_invalid_mood_attrs = FactoryGirl.attributes_for(:invalid_mood).as_json
          put :update, :id => @spec_mood.as_json["id"], :mood_rating => @spec_invalid_mood_attrs["mood_rating"], :anxiety_rating => @spec_invalid_mood_attrs["anxiety_rating"], :irritability_rating => @spec_invalid_mood_attrs["irritability_rating"], format: :json
          xhr :get, :edit, :id => @spec_mood.as_json["id"], :mood_rating => @spec_updated_mood_attrs["mood_rating"], :anxiety_rating => @spec_updated_mood_attrs["anxiety_rating"], :irritability_rating => @spec_updated_mood_attrs["irritability_rating"]
        end

        it "gives an error flash message" do
          @spec_invalid_mood_attrs = FactoryGirl.attributes_for(:invalid_mood).as_json
          put :update, :id => @spec_mood.as_json["id"], :mood_rating => @spec_invalid_mood_attrs["mood_rating"], :anxiety_rating => @spec_invalid_mood_attrs["anxiety_rating"], :irritability_rating => @spec_invalid_mood_attrs["irritability_rating"], format: :json
          expect(flash[:error]).to eq("Journal Entry was not updated... Try again???")
        end
      end 
=end
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
        @spec_journal_attrs = FactoryGirl.attributes_for(:journal, user: @spec_user).as_json
        @spec_journal = FactoryGirl.create(:journal, @spec_journal_attrs)
      end

      context "with JS request" do
        it "re-renders JS for index method" do 
          xhr :get, :delete, journal_id: @spec_journal.as_json["id"], format: :js
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
        delete :destroy, id: 1
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
        @spec_journal_attrs = FactoryGirl.attributes_for(:journal, user: @spec_user).as_json
        @spec_journal = FactoryGirl.create(:journal, @spec_journal_attrs)
      end 

      context "with JS request" do
        it "deletes the journal" do 
          expect{ 
            xhr :delete, :destroy, id: @spec_journal.as_json["id"]
          }.to change(Journal,:count).by(-1) 
        end 

        it "re-renders JS for index method" do 
          xhr :delete, :destroy, id: @spec_journal.as_json["id"]
          xhr :get, :index, @params
        end

        it "gives a success flash message" do 
          xhr :delete, :destroy, id: @spec_journal.as_json["id"], format: :js
          expect(flash[:success]).to eq("Journal Entry was successfully deleted.")
        end
      end

      context "with JSON request" do
        it "deletes the journal" do 
          expect{ 
            delete :destroy, id: @spec_journal.as_json["id"], format: :json
          }.to change(Journal,:count).by(-1) 
        end 

        it "returns a no content 204 response" do 
          delete :destroy, id: @spec_journal.as_json["id"], format: :json
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