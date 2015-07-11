class MoodsController < ApplicationController
  acts_as_token_authentication_handler_for User

  before_action :set_mood, only: [:show, :edit, :update, :destroy]
  before_action :set_lookback_period, only: [:index]
  before_action :authenticate_user!

  after_filter :verify_authorized,  except: [:index]
  after_filter :verify_policy_scoped, only: [:index]

  respond_to :html, :js, :json, :xml
  
  # GET /moods
  # GET /moods.json
  def index
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      @moods = Mood.where(user_id: current_user.id)
      skip_authorization
    elsif @user != nil
      @moods = Mood.where(user_id: @user.id)
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @moods
      end
    end

    @moods = policy_scope(@moods)
   
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
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @moods
      end
    end

    @mood= Mood.new
  end

  # GET /moods/1/edit
  def edit
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @moods
      end
    end
  end

  # POST /moods
  # POST /moods.json
  def create
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @moods
      end
    end

    @mood = Mood.new(mood_params)
    @mood.user_id = current_user.id
    @mood.update_attribute(:timestamp, DateTime.now.in_time_zone)
    
    respond_to do |format|
      if @mood.save
        track_mood_created

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
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @moods
      end
    end
    
    respond_to do |format|
      if @mood.update(mood_params)
        track_mood_updated

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
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @moods
      end
    end

    @mood = Mood.find(params[:mood_id])
  end

  # DELETE /moods/1
  # DELETE /moods/1.json
  def destroy
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @moods
      end
    end
    
    @mood.destroy
    track_mood_deleted
    
    respond_to do |format|
      flash.now[:success] = "Mood Entry was successfully deleted."
      format.js 
      format.json { head :no_content }
    end
  end

  def cancel
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @moods
      end
    end
    
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mood
      @mood = Mood.find(params[:id])
    end

    def set_lookback_period
      if(params.has_key?(:mood_lookback_period))
        @mood_lookback_period = params[:mood_lookback_period]
      else
        @mood_lookback_period = DEFAULT_LOOKBACK_PERIOD
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mood_params
      params.fetch(:mood, {}).permit(:mood_rating, :anxiety_rating, :irritability_rating, :timestamp, :mood_lookback_period)
    end

    def track_mood_created
      # Track Mood Creation for Segment.io Analytics
      Analytics.track(
        user_id: @mood.user_id,
        event: 'Created Mood Entry',
        properties: {
          mood_id: @mood.id,
          mood_rating: @mood.mood_rating,
          anxiety_rating: @mood.anxiety_rating,
          irritability_rating: @mood.irritability_rating,
          timestamp: @mood.timestamp
        }
      )
    end

    def track_mood_updated
      # Track Mood Update for Segment.io Analytics
      Analytics.track(
        user_id: @mood.user_id,
        event: 'Updated Mood Entry',
        properties: {
          mood_id: @mood.id,
          mood_rating: @mood.mood_rating,
          anxiety_rating: @mood.anxiety_rating,
          irritability_rating: @mood.irritability_rating,
          timestamp: @mood.timestamp
        }
      )
    end

    def track_mood_deleted
      # Track Mood Deletion for Segment.io Analytics
      Analytics.track(
        user_id: @mood.user_id,
        event: 'Deleted Mood Entry',
        properties: {
        }
      )
    end
end