class SelfCaresController < ApplicationController
  acts_as_token_authentication_handler_for User

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  #load_and_authorize_resource
  check_authorization

  before_action :set_self_care, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  respond_to :html, :js, :json, :xml

  Time.zone = 'EST'
  
  # GET /self_cares
  # GET /self_cares.json
  def index
    authorize! :manage, SelfCare
    authorize! :read, SelfCare
    @user = User.find_by_id(params[:user_id])
    
    if @user == nil
      @self_cares = SelfCare.where(user_id: current_user.id)
    elsif @user != nil
      @self_cares = SelfCare.where(user_id: @user.id)
    end

    respond_to do |format|
      format.html
      format.js
      format.json { render :json => @self_cares, status: 200 }
      format.xml { render :xml => @self_cares, status: 200 }
    end
  end

  # GET /self_cares/1
  # GET /self_cares/1.json
  def show
    authorize! :manage, SelfCare
    authorize! :read, SelfCare
    
    respond_to do |format|
      format.js
      format.json { render :json =>  @self_care, status: 200 }
      format.xml { render :xml => @self_care, status: 200 }
    end
  end

  # GET /self_cares/new
  def new
    authorize! :manage, SelfCare
    @self_care= SelfCare.new
  end

  # GET /self_cares/1/edit
  def edit
    authorize! :manage, SelfCare
  end

  # POST /self_cares
  # POST /self_cares.json
  def create
    authorize! :manage, SelfCare
    @self_care = SelfCare.new(self_care_params)
    @self_care.user_id = current_user.id
    
    respond_to do |format|
      if @self_care.save
        current_user.scorecards.update_scorecard('self_cares')
        flash.now[:success] = "Self Entry was successfully tracked."
        format.js
        format.json { render :json => @self_care, status: :created }
      else
        format.js   { render json: @self_care.errors, status: :unprocessable_entity }
        format.json { render json: @self_care.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /self_cares/1
  # PATCH/PUT /self_cares/1.json
  def update
    authorize! :manage, SelfCare
    
    respond_to do |format|
      if @self_care.update(self_care_params)
        flash.now[:success] = "Self Care Entry was successfully updated."
        format.js
        format.json { render :json => @self_care, status: :created }
      else
        flash.now[:error] = 'Self Care Entry was not updated... Try again???'
        format.js   { render json: @self_care.errors, status: :unprocessable_entity }
        format.json { render json: @self_care.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete
    authorize! :manage, SelfCare
    @self_care = SelfCare.find(params[:self_care_id])
  end

  # DELETE /self_cares/1
  # DELETE /self_cares/1.json
  def destroy
    authorize! :manage, SelfCare
    @self_care.destroy
    
    respond_to do |format|
      flash.now[:success] = "Self Care Entry was successfully removed."
      format.js 
      format.json { head :no_content }
    end
  end

  def cancel
    authorize! :manage, SelfCare
    authorize! :read, SelfCare
    
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_self_care
      @self_care = SelfCare.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def self_care_params
      params.fetch(:self_care, {}).permit(:counseling, :medication, :meditation, :exercise)
    end
end