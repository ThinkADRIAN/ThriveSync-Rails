require 'spec_helper' 

describe MoodsController, :type => :controller do
  include Devise::TestHelpers

  describe "GET #index" do 
    context "with anonymous user" do
      before :each do
        # This simulates an anonymous user
        login_with nil
      end
      it "should be redirected to signin" do
        get :index
        expect( response ).to redirect_to( new_user_session_path )
      end
    end
    
    context "with authenticated user" do
      before :each do
        # This simulates an authenticated user
        user = FactoryGirl.create(:user)
        login_with user
      end

      it "populates an array of moods" do 
        mood = FactoryGirl.create(:mood) 
        get :index
        expect(assigns(:moods)).to eq([mood])
      end
      it "renders the :index view" do
        get :index 
        response.should render_template :index
      end
      it "renders js output" 
      it "renders json output"
    end
  end 

  describe "GET #show" do 
    it "assigns the requested mood to @mood" 
    #it "renders the :show template" 
    it "renders js output" 
    it "renders json output" 
  end 

  describe "GET #new" do 
    it "assigns a new Mood to @mood" 
    it "renders the :new template" 
  end 

  describe "GET #edit" do 
    it "assigns an existing Mood to @mood" 
    it "renders the :edit template" 
  end

  describe "POST #create" do 
    context "with valid attributes" do 
      it "saves the new mood in the database" 
      #it "redirects to the home page" 
      it "gives a success flash message"
      it "renders js output" 
      it "renders json output" 
    end 

    context "with invalid attributes" do 
      it "does not save the new mood in the database" 
      #it "re-renders the :new template" 
      it "gives an error flash message"
      it "renders js error" 
      it "renders json error" 
    end 
  end

  describe "PATCH/PUT #update" do 
    context "with valid attributes" do 
      it "saves the existing mood in the database" 
      #it "redirects to the home page"  
      it "gives a success flash message"
      it "renders js output" 
      it "renders json output" 
    end 

    context "with invalid attributes" do 
      it "does not save the existing mood in the database" 
      #it "re-renders the :new template" 
      it "gives an error flash message"
      it "renders js error" 
      it "renders json error" 
    end 
  end

  describe "GET #delete" do 
    it "assigns an existing Mood to @mood" 
    it "renders the :delete template" 
  end

  describe "DELETE #destroy" do 
    context "with valid attributes" do 
      it "deletes the existing mood in the database" 
      #it "redirects to the home page"   
      it "gives a success flash message"
      it "renders js output" 
      it "renders json output" 
    end 

    context "with invalid attributes" do 
      it "does not delete the existing mood in the database" 
      #it "re-renders the :new template" 
      it "gives an error flash message"
      it "renders js error" 
      it "renders json error" 
    end 
  end

  describe "GET #cancel" do 
    it "assigns an existing Mood to @mood" 
    it "renders the :cancel template" 
  end
end