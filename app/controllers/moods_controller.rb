class MoodsController < ApplicationController
  acts_as_token_authentication_handler_for User

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  #load_and_authorize_resource
  check_authorization

  before_action :set_mood, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  respond_to :html, :js, :json, :xml

  Time.zone = 'EST'
  
  # GET /moods
  # GET /moods.json
  def index
    authorize! :manage, Mood
    authorize! :read, Mood
    @user = User.find_by_id(params[:user_id])
    
    if @user == nil
      @moods = Mood.where(user_id: current_user.id)
    elsif @user != nil
      @moods = Mood.where(user_id: @user.id)
    end
   
    respond_to do |format|
      format.html
      format.js
      format.json { render :json => @moods, status: 200 }
      format.xml { render :xml => @moods, status: 200 }
    end
  end

  # GET /moods/1
  # GET /moods/1.json
  def show
    authorize! :manage, Mood
    authorize! :read, Mood
    
    respond_to do |format|
      format.js
      format.json { render :json =>  @mood, status: 200 }
      format.xml { render :xml => @mood, status: 200 }
    end
  end

  # GET /moods/new
  def new
    authorize! :manage, Mood
    @mood= Mood.new
  end

  # GET /moods/1/edit
  def edit
    authorize! :manage, Mood
  end

  # POST /moods
  # POST /moods.json
  def create
    authorize! :manage, Mood
    @mood = Mood.new(mood_params)
    @mood.user_id = current_user.id
    @mood.update_attribute(:timestamp, DateTime.now.in_time_zone)
    
    respond_to do |format|
      if @mood.save
        current_user.scorecard.update_scorecard('moods')
        flash.now[:success] = "Mood Entry was successfully tracked."
        format.js 
        format.json { render :json => @mood, status: :created }
      else
        format.js   { render json: @mood.errors, status: :unprocessable_entity }
        format.json { render json: @mood.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /moods/1
  # PATCH/PUT /moods/1.json
  def update
    authorize! :manage, Mood
    
    respond_to do |format|
      if @mood.update(mood_params)
        flash.now[:success] = "Mood Entry was successfully updated."
        format.js
        format.json { render :json => @mood, status: :created }
      else
        flash.now[:error] = 'Mood Entry was not updated... Try again???'
        format.js   { render json: @mood.errors, status: :unprocessable_entity }
        format.json { render json: @mood.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete
    authorize! :manage, Mood
    @mood = Mood.find(params[:mood_id])
  end

  # DELETE /moods/1
  # DELETE /moods/1.json
  def destroy
    authorize! :manage, Mood
    @mood.destroy
    
    respond_to do |format|
      flash.now[:success] = "Mood Entry was successfully deleted."
      format.js 
      format.json { head :no_content }
    end
  end

  def cancel
    authorize! :manage, Mood
    authorize! :read, Mood
    
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mood
      @mood = Mood.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mood_params
      params.fetch(:mood, {}).permit(:mood_rating, :anxiety_rating, :irritability_rating)
    end
end