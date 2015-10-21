class SelfCaresController < ApplicationController
  resource_description do
    short 'Self Care Entries'
    desc <<-EOS
      == Long description
        Self Care Entries include:
          Counseling
          Medication
          Meditation
          Exercise
          Timestamp

      ===Sample JSON Output:
          {
            "self_cares": [
              {
                "id": 2213,
                "counseling": true,
                "medication": true,
                "meditation": false,
                "exercise": false,
                "timestamp": "2014-10-27 00:02:00 -0400",
                "created_at": "2014-10-27 15:11:49 -0400",
                "updated_at": "2014-11-01 20:02:31 -0400",
                "user_id": 24
              }
            ]
          }
      EOS
    api_base_url ""
    formats ['html', 'json']
  end

  def_param_group :self_cares_data do
    param :self_care, Hash , :desc => "Self Care", :required => false do
      param :counseling, :undef, :desc => "Counseling [Boolean]", :required => true
      param :medication, :undef, :desc => "Medication [Boolean]", :required => true
      param :meditation, :undef, :desc => "Meditation [Boolean]", :required => true
      param :exercise, :undef, :desc => "Exercise [Boolean]", :required => true
    end
  end

  def_param_group :self_cares_all do
    param_group :self_cares_data
    param :timestamp, :undef, :desc => "Timestamp for Self Care Entry [DateTime(UTC)]", :required => false
  end

  def_param_group :destroy_self_cares_data do
    param :id, :number, :desc => "Id of Self Care Entry to Delete [Number]", :required => true
  end

  acts_as_token_authentication_handler_for User

  before_action :set_self_care, only: [:show, :edit, :update, :destroy]
  before_action :set_lookback_period, only: [:index]
  before_action :authenticate_user!

  after_filter :verify_authorized,  except: [:index]
  #after_filter :verify_policy_scoped, only: [:index]

  respond_to :html, :js, :json
  
  # GET /self_cares
  # GET /self_cares.json
  api! "Show Self Care Entries"
  def index
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      @self_cares = SelfCare.where(user_id: current_user.id)
      skip_authorization
    elsif @user != nil
      @self_cares = SelfCare.where(user_id: @user.id)
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @self_cares
      end
    end

    #@self_cares = policy_scope(@self_cares)

    respond_to do |format|
      format.html
      format.js
      format.json { render :json => @self_cares, status: 200 }
    end
  end

  # GET /self_cares/1
  # GET /self_cares/1.json
  def show
    authorize! :manage, SelfCare
    authorize! :read, SelfCare
    
    respond_to do |format|
      format.html { render nothing: true }
      format.js
      format.json { render :json =>  @self_care, status: 200 }
    end
  end

  # GET /self_cares/new
  def new
    @user = User.find_by_id(params[:user_id])
    $capture_source = params[:capture_source]

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @self_cares
      end
    end

    @self_care= SelfCare.new

    respond_to do |format|
      format.html { render :nothing => true }
      format.js
      format.json { render :json =>  @self_care, status: 200 }
    end
  end

  # GET /self_cares/1/edit
  def edit
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @self_cares
      end
    end

    respond_to do |format|
      format.html { render :nothing => true }
      format.js
      format.json { render :json =>  @self_care, status: 200 }
    end
  end

  # POST /self_cares
  # POST /self_cares.json
  api! "Create Self Care Entry"
  param_group :self_cares_data
  def create
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @self_cares
      end
    end

    @self_care = SelfCare.new(self_care_params)
    @self_care.user_id = current_user.id

    todays_self_cares = SelfCare.where(user_id: current_user.id, timestamp: (Date.today.at_beginning_of_day.in_time_zone..Date.today.end_of_day.in_time_zone))


    if params[:timestamp].nil?
      if $capture_source == 'self_care'
        d = $capture_date
        t = Time.now
        dt = DateTime.new(d.year, d.month, d.day, t.hour, t.min, t.sec, t.zone)

        @self_care.timestamp = dt
      else
        @self_care.timestamp = DateTime.now.in_time_zone
      end
    end
    
    respond_to do |format|
      if todays_self_cares.count < MAX_SELF_CARE_ENTRIES
        if @self_care.save
          track_self_care_created
          current_user.scorecard.update_scorecard('self_cares')
          flash.now[:success] = 'Self Entry was successfully tracked.'
          format.js
          format.json { render :json => @self_care, status: :created }
        else
          flash.now[:error] = 'Self Care Entry was not tracked... Try again???'
          format.js   { render json: @self_care.errors, status: :unprocessable_entity }
          format.json { render json: @self_care.errors, status: :unprocessable_entity }
        end
      else
        flash.now[:warning] = 'Self Care Entry was not tracked.  Daily Self Care Entry Limit Reached.'
        format.js
        format.json { render json: 'Self Care Entry was not tracked.  Daily Self Care Entry Limit Reached.', status: 400 }
      end
    end
  end

  # PATCH/PUT /self_cares/1
  # PATCH/PUT /self_cares/1.json
  api! "Update Self Care Entry"
  param_group :self_cares_all
  def update
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @self_cares
      end
    end
    
    respond_to do |format|
      if @self_care.update(self_care_params)
        track_self_care_updated
        flash.now[:success] = 'Self Care Entry was successfully updated.'
        format.js { render status: 200 }
        format.json { render :json => @self_care, status: :created }
      else
        flash.now[:error] = 'Self Care Entry was not updated... Try again???'
        format.js   { render json: @self_care.errors, status: :unprocessable_entity }
        format.json { render json: @self_care.errors, status: :unprocessable_entity }
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
        authorize @self_cares
      end
    end

    @self_care = SelfCare.find(params[:self_care_id])
  end

  # DELETE /self_cares/1
  # DELETE /self_cares/1.json
  api! "Delete Self Care Entry"
  param_group :destroy_self_cares_data
  def destroy
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @self_cares
      end
    end

    respond_to do |format|
      if @self_care.destroy
        track_self_care_deleted
        flash[:success] = 'Self Care Entry was successfully deleted.'
        format.html { redirect_to self_cares_path }
        format.js
        format.json { head :no_content }
      else
        flash[:error] = 'Self Care Entry was not deleted... Try again???'
        format.html { redirect self_cares_path }
        format.js
        format.json { render json: @self_cares.errors, status: :unprocessable_entity }
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
        authorize @self_cares
      end
    end

    $current_capture_screen = 'SelfCare'
    
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_self_care
      @self_care = SelfCare.find(params[:id])
    end

    def set_lookback_period
      if params.has_key? :self_care_lookback_period
        @self_care_lookback_period = params[:self_care_lookback_period]
      else
        @self_care_lookback_period = DEFAULT_LOOKBACK_PERIOD
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def self_care_params
      params.fetch(:self_care, {}).permit(:counseling, :medication, :meditation, :exercise, :timestamp, :self_care_lookback_period, :capture_source)
    end

    def track_self_care_created
      # Track Self Care Creation for Segment.io Analytics
      Analytics.track(
        user_id: current_user.id,
        event: 'Self Care Entry Created',
        properties: {
          self_care_id: @self_care.id,
          counseling: @self_care.counseling,
          medication: @self_care.medication,
          meditation: @self_care.meditation,
          exercise: @self_care.exercise,
          timestamp: @self_care.timestamp,
          self_care_user_id: @self_care.user_id
        }
      )
    end

    def track_self_care_updated
      # Track Self Care Update for Segment.io Analytics
      Analytics.track(
        user_id: current_user.id,
        event: 'Self Care Entry Updated',
        properties: {
          self_care_id: @self_care.id,
          counseling: @self_care.counseling,
          medication: @self_care.medication,
          meditation: @self_care.meditation,
          exercise: @self_care.exercise,
          timestamp: @self_care.timestamp,
          self_care_user_id: @self_care.user_id
        }
      )
    end

    def track_self_care_deleted
      # Track Self Care Deletion for Segment.io Analytics
      Analytics.track(
        user_id: current_user.id,
        event: 'Self Care Entry Deleted',
        properties: {
        }
      )
    end
end