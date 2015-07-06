class SleepsController < ApplicationController
  acts_as_token_authentication_handler_for User

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  #load_and_authorize_resource
  check_authorization

  before_action :set_sleep, only: [:show, :edit, :update, :destroy]
  before_action :set_lookback_period, only: [:index]
  before_action :authenticate_user!

  respond_to :js
  
  # GET /sleeps
  # GET /sleeps.json
  def index
    authorize! :manage, Sleep
    authorize! :read, Sleep
    @user = User.find_by_id(params[:user_id])
    if @user == nil
      @sleeps = Sleep.where(user_id: current_user.id)
    elsif @user != nil
      @sleeps = Sleep.where(user_id: @user.id)
    end

    respond_to do |format|
      format.html
      format.js
      format.json { render :json => @sleeps, status: 200 }
      format.xml { render :xml => @sleeps, status: 200 }
    end
  end

  # GET /sleeps/1
  # GET /sleeps/1.json
  def show
    authorize! :manage, Sleep
    authorize! :read, Sleep

    respond_to do |format|
      format.js
      format.json { render :json =>  @sleep, status: 200 }
      format.xml { render :xml => @sleep, status: 200 }
    end
  end

  # GET /sleeps/new
  def new
    authorize! :manage, Sleep
    @sleep= Sleep.new
  end

  # GET /sleeps/1/edit
  def edit
    authorize! :manage, Sleep
  end

  # POST /sleeps
  # POST /sleeps.json
  def create
    authorize! :manage, Sleep
    @sleep = Sleep.new(sleep_params)
    @sleep.user_id = current_user.id
    @sleep.time = (@sleep.finish_time.to_i - @sleep.start_time.to_i) / 3600
    
    respond_to do |format|
      if @sleep.save
        track_sleep_created
        current_user.scorecard.update_scorecard('sleeps')
        flash.now[:success] = 'Sleep Entry was successfully tracked.'
        format.js 
        format.json { render :json => @sleep, status: :created }
      else
        format.js { render json: @sleep.errors, status: :unprocessable_entity }
        format.json { render json: @sleep.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sleeps/1
  # PATCH/PUT /sleeps/1.json
  def update
    authorize! :manage, Sleep

    respond_to do |format|
      if @sleep.update(sleep_params)
        @sleep.time = (@sleep.finish_time.to_i - @sleep.start_time.to_i) / 3600
        @sleep.save
        track_sleep_updated

        flash.now[:success] = 'Sleep Entry was successfully updated.'
        format.js
        format.json { render :json => @sleep, status: :created }
      else
        flash.now[:error] = 'Sleep Entry was not updated... Try again???'
        format.js { render json: @sleep.errors, status: :unprocessable_entity }
        format.json { render json: @sleep.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete
    authorize! :manage, Sleep
    @sleep = Sleep.find(params[:sleep_id])
  end

  # DELETE /sleeps/1
  # DELETE /sleeps/1.json
  def destroy
    authorize! :manage, Sleep
    @sleep.destroy
    track_sleep_deleted

    respond_to do |format|
      flash.now[:success] = 'Sleep Entry was successfully removed.'
      format.js
      format.json { head :no_content }
    end
  end

  def cancel
    authorize! :manage, Sleep
    authorize! :read, Sleep
    
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sleep
      @sleep = Sleep.find(params[:id])
    end

    def set_lookback_period
      if(params.has_key?(:sleep_lookback_period))
        @sleep_lookback_period = params[:sleep_lookback_period]
      else
        @sleep_lookback_period = DEFAULT_LOOKBACK_PERIOD
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sleep_params
      params.fetch(:sleep, {}).permit(:start_time, :finish_time, :quality, :sleep_lookback_period)
    end

    def track_sleep_created
      # Track Sleep Creation for Segment.io Analytics
      Analytics.track(
        user_id: @sleep.user_id,
        event: 'Created Sleep Entry',
        properties: {
          sleep_id: @sleep.id,
          start_time: @sleep.start_time,
          finish_time: @sleep.finish_time,
          quality: @sleep.quality
        }
      )
    end

    def track_sleep_updated
      # Track Sleep Update for Segment.io Analytics
      Analytics.track(
        user_id: @sleep.user_id,
        event: 'Updated Sleep Entry',
        properties: {
          sleep_id: @sleep.id,
          start_time: @sleep.start_time,
          finish_time: @sleep.finish_time,
          quality: @sleep.quality
        }
      )
    end

    def track_sleep_deleted
      # Track Sleep Deletion for Segment.io Analytics
      Analytics.track(
        user_id: @sleep.user_id,
        event: 'Deleted Sleep Entry',
        properties: {
        }
      )
    end
end