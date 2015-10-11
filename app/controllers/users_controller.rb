class UsersController < ApplicationController
  resource_description do
    name 'Thrivers'
    short 'Thrivers'
    desc <<-EOS
      == Long description
        Thrivers are the primary users of ThriveSync
      EOS

    api_base_url ""
    formats ['html', 'json']
  end

  def_param_group :thrivers_data do
    param :first_name, :undef, :desc => "First Name of Thriver [String]", :required => true
    param :last_name, :undef, :desc => "Last Name of Thriver [String]", :required => true
    param :email, :undef, :desc => "Email Address of Thriver [String]", :required => true
  end

  def_param_group :thrivers_migration_data do
    param :email, :undef, :desc => "Email Address of Thriver [String]", :required => true
    param :password, :undef, :desc => "Password of Thriver [String]", :required => true
  end

  include ParseHelper

  acts_as_token_authentication_handler_for User

  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  before_filter :authorize_user_index, :only => [:index, :show]
  before_filter :authorize_user_edit, :only => [:edit, :update]
  before_filter :authorize_user_destroy, :only => [:destroy]

  after_action :verify_authorized

  respond_to :html, :json
  
  api! "Show Thriver"
  def index
    # Pundit authorization can be skipped because
    # before_filter :authorize_user_index handles authorization
    skip_authorization 

    @user = User.find_by_id(params[:id])

    if @user == nil
      @user = User.find_by_id(current_user.id)
    end

    respond_to do |format|
      format.html
      format.json { render :json => @user, status: 200 }
    end
  end

  # GET /users/:id.:format
  def show
    # Pundit authorization can be skipped because
    # before_filter :authorize_user_index handles authorization
    skip_authorization 

    @user = User.find_by_id(params[:id])

    if @user == nil
      @user = User.find_by_id(current_user.id)
    end

    respond_to do |format|
      format.html
      format.json { render :json => @user, status: 200 }
    end
  end

  def create
    authorize :user, :create?
    @user = User.new(user_params)
    @user.save
    
    respond_to do |format|
      format.html
      format.json { render :json => @user, status: 200 }
    end
  end

  def new
    authorize :user, :new?
    @user = User.new
    
    respond_to do |format|
      format.html
      format.json { render :json => @user, status: 200 }
    end
  end

  # GET /users/:id/edit
  def edit
    # Pundit authorization can be skipped because
    # before_filter :authorize_user_edit handles authorization
    authorize :user, :edit? # skip_authorization

    respond_to do |format|
      format.html
      format.json { render :json => @user, status: 200 }
    end
  end

  # PATCH/PUT /users/:id.:format
  def update
    # Pundit authorization can be skipped because
    # before_filter :authorize_user_edit handles authorization
    authorize :user, :update? # skip_authorization

    authorize! :assign_roles, current_user if params[:user][:assign_roles]
    respond_to do |format|
      if @user.update(user_params)
        sign_in(@user == current_user ? @user : current_user, :bypass => true)
        format.html { redirect_to @user, notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    authorize :user, :finish_signup?
    @user = User.find params[:id]
    authorize! :assign_roles, current_user if params[:user][:assign_roles]
    if request.patch? && params[:user] && params[:user][:email]
      if @rails_user.update(user_params)
        @user.skip_reconfirmation!
        sign_in(@user, :bypass => true)
        redirect_to @user, notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
      end
    end
  end

  # DELETE /users/:id.:format
  def destroy
    # Pundit authorization can be skipped because
    # before_filter :authorize_user_destroy handles authorization
    authorize :user, :destroy? # skip_authorization

    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  api! "Migrate from ThriverTracker"
  param_group :thrivers_migration_data
  def migrate_from_thrivetracker
    authorize :user, :migrate_from_thrivetracker?
    etl_for_parse(current_user.id, params[:email], params[:password])
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  api! "Request Password Reset From ThriveTracker"
  def request_password_reset_from_thrivetracker
    authorize :user, :request_password_reset_from_thrivetracker?
    resp = Parse::User.reset_password(current_user.email)
    puts resp
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end
  
  protected
  
  def user_access_granted_index?
    ((current_user.is? :pro) && (current_user.clients.include?(params[:id].to_i))) || 
    (current_user.id == params[:id].to_i) || (current_user.is? :superuser) || (current_user && (params[:id] == nil) )
  end

  def user_access_granted_edit?
    (current_user.is? :superuser) || (current_user && (params[:id] == nil) )
  end

  def user_access_granted_destroy?
    (current_user.is? :superuser) || (current_user && (params[:id] == nil) )
  end

  def authorize_user_index
    unless user_access_granted_index?
      user_not_authorized
    end
  end

  def authorize_user_edit
    unless user_access_granted_edit?
      user_not_authorized
    end
  end

  def authorize_user_destroy
    unless user_access_granted_destroy?
      user_not_authorized
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      accessible = [ :first_name, :last_name, :email, roles: [], clients: [], supporters: [] ] # extend with your own params
      accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
      params.fetch(:user, {}).permit(accessible)
    end
end
