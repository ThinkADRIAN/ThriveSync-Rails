class SleepsController < ApplicationController
  resource_description do
    short 'Sleep Entries'
    desc <<-EOS
      == Long description
        Sleep Entries include:
          Start Time
          Finish Time
          Quality
          Time

      ===Sample JSON Output:
          {
            "sleeps": [
              {
                "id": 2657,
                "start_time": "2014-10-27 00:30:00 -0400",
                "finish_time": "2014-10-27 06:00:00 -0400",
                "quality": 2,
                "time": 5,
                "created_at": "2014-10-27 06:02:09 -0400",
                "updated_at": "2014-10-27 06:02:09 -0400",
                "user_id": 24
              }
            ]
          }
      EOS
    api_base_url ""
    formats ['html', 'json']
  end

  def_param_group :sleeps_data do
    param :sleep, Hash , :desc => "Sleep", :required => false do
      param :start_time, :undef, :desc => "Sleep Start Time [DateTime(UTC)]", :required => true
      param :finish_time, :undef, :desc => "Sleep Finish Time [DateTime(UTC)]", :required => true
      param :quality, :number, :desc => "[['Broken', 1], ['Light', 2], ['Normal', 3], ['Deep',4]]", :required => true
    end
  end

  def_param_group :sleeps_all do
    param_group :sleeps_data
  end

  def_param_group :destroy_sleeps_data do
    param :id, :number, :desc => "Id of Sleep Entry to Delete [Number]", :required => true
  end

  acts_as_token_authentication_handler_for User

  before_action :set_sleep, only: [:show, :edit, :update, :destroy]
  before_action :set_lookback_period, only: [:index]
  before_action :authenticate_user!

  after_filter :verify_authorized,  except: [:index]
  #after_filter :verify_policy_scoped, only: [:index]

  respond_to :html, :js, :json
  
  # GET /sleeps
  # GET /sleeps.json
  api! "Show Sleep Entries"
  def index
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      @sleeps = Sleep.where(user_id: current_user.id)
      skip_authorization
    elsif @user != nil
      @sleeps = Sleep.where(user_id: @user.id)
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @sleeps
      end
    end

    #@sleeps = policy_scope(@sleeps)

    respond_to do |format|
      format.html
      format.js
      format.json { render :json => @sleeps, status: 200 }
    end
  end

  # GET /sleeps/1
  # GET /sleeps/1.json
  def show
    authorize! :manage, Sleep
    authorize! :read, Sleep

    respond_to do |format|
      format.js { render :nothing => true }
      format.json { render :json =>  @sleep, status: 200 }
    end
  end

  # GET /sleeps/new
  def new
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @sleeps
      end
    end

    @sleep= Sleep.new

    respond_to do |format|
      format.html { render :nothing => true }
      format.js
      format.json { render :json =>  @sleep, status: 200 }
    end
  end

  # GET /sleeps/1/edit
  def edit
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @sleeps
      end
    end

    respond_to do |format|
      format.html { render :nothing => true }
      format.js
      format.json { render :json =>  @sleep, status: 200 }
    end
  end

  # POST /sleeps
  # POST /sleeps.json
  api! "Create Sleep Entry"
  param_group :sleeps_data
  def create
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @sleeps
      end
    end

    @sleep = Sleep.new(sleep_params)
    @sleep.user_id = current_user.id
    @sleep.time = (@sleep.finish_time.to_i - @sleep.start_time.to_i) / 3600

    todays_sleeps = Sleep.where(user_id: current_user.id, finish_time: (Date.today.in_time_zone.at_beginning_of_day..Date.today.in_time_zone.end_of_day))

    respond_to do |format|
      if todays_sleeps.count < MAX_SLEEP_ENTRIES
        if @sleep.save
          track_sleep_created
          current_user.scorecard.update_scorecard('sleeps')
          flash.now[:success] = 'Sleep Entry was successfully tracked.'
          format.js
          format.json { render :json => @sleep, status: :created }
        else
          flash.now[:error] = 'Sleep Entry was not tracked... Try again???'
          format.js { render json: @sleep.errors, status: :unprocessable_entity }
          format.json { render json: @sleep.errors, status: :unprocessable_entity }
        end
      else
        flash.now[:warning] = 'Sleep Entry was not tracked.  Daily Sleep Entry Limit Reached.'
        format.js
        format.json { render json: 'Sleep Entry was not tracked.  Daily Sleep Entry Limit Reached.', status: 400 }
      end
    end
  end

  # PATCH/PUT /sleeps/1
  # PATCH/PUT /sleeps/1.json
  api! "Update Sleep Entry"
  param_group :sleeps_all
  def update
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @sleeps
      end
    end

    finish_time = sleep_params[:finish_time].to_datetime
    days_sleeps = Sleep.where(user_id: current_user.id, finish_time: (finish_time.in_time_zone.at_beginning_of_day..finish_time.in_time_zone.end_of_day))

    respond_to do |format|
      if days_sleeps.count < MAX_SLEEP_ENTRIES - 1
        if @sleep.update(sleep_params)
          @sleep.time = (@sleep.finish_time.to_i - @sleep.start_time.to_i) / 3600
          @sleep.save
          track_sleep_updated

          flash.now[:success] = 'Sleep Entry was successfully updated.'
          format.js { render status: 200 }
          format.json { render :json => @sleep, status: :created }
        else
          flash.now[:error] = 'Sleep Entry was not updated... Try again???'
          format.js { render json: @sleep.errors, status: :unprocessable_entity }
          format.json { render json: @sleep.errors, status: :unprocessable_entity }
        end
      else
        flash.now[:error] = 'Sleep Entry was not updated.  Daily Sleep Entry Limit Reached.'
        format.js
        format.json { render json: 'Sleep Entry was not updated.  Daily Sleep Entry Limit Reached.', status: 400 }
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
        authorize @sleeps
      end
    end

    @sleep = Sleep.find(params[:sleep_id])
  end

  # DELETE /sleeps/1
  # DELETE /sleeps/1.json
  api! "Delete Sleep Entry"
  param_group :destroy_sleeps_data
  def destroy
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @sleeps
      end
    end

    respond_to do |format|
      if @sleep.destroy
        track_sleep_deleted
        flash[:success] = 'Sleep Entry was successfully deleted.'
        format.html { redirect_to sleeps_path }
        format.js
        format.json { head :no_content }
      else
        flash[:error] = 'Sleep Entry was not deleted... Try again???'
        format.html { redirect sleeps_path }
        format.js
        format.json { render json: @sleeps.errors, status: :unprocessable_entity }
      end
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
        authorize @sleeps
      end
    end

    $current_capture_screen = "Sleep"

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
      if params.has_key? :sleep_lookback_period
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
        user_id: current_user.id,
        event: 'Sleep Entry Created',
        properties: {
          sleep_id: @sleep.id,
          start_time: @sleep.start_time,
          finish_time: @sleep.finish_time,
          quality: @sleep.quality,
          sleep_user_id: @sleep.user_id
        }
      )
    end

    def track_sleep_updated
      # Track Sleep Update for Segment.io Analytics
      Analytics.track(
        user_id: current_user.id,
        event: 'Sleep Entry Updated',
        properties: {
          sleep_id: @sleep.id,
          start_time: @sleep.start_time,
          finish_time: @sleep.finish_time,
          quality: @sleep.quality,
          sleep_user_id: @sleep.user_id
        }
      )
    end

    def track_sleep_deleted
      # Track Sleep Deletion for Segment.io Analytics
      Analytics.track(
        user_id: current_user.id,
        event: 'Sleep Entry Deleted',
        properties: {
        }
      )
    end
end