class JournalsController < ApplicationController
  resource_description do
    short 'Journal Entries'
    desc <<-EOS
      == Long description
        Journal Entries include:
          Journal Entry
          Timestamp

      ===Sample JSON Output:
          {
            "journals": [
              {
                "id": 1064,
                "journal_entry": "Rivers know this: there is no hurry. We shall get there some day.",
                "timestamp": "2014-12-02 12:45:00 -0500",
                "created_at": "2014-12-02 08:45:10 -0500",
                "updated_at": "2014-12-02 08:45:10 -0500",
                "user_id": 24
              }
            ]
          }
      EOS
    api_base_url ""
    formats ['html', 'json']
  end

  def_param_group :journals_data do
    param :journal, Hash , :desc => "Journal", :required => false do
      param :journal_entry, :undef, :desc => "Journal Entry [String]", :required => true
    end
  end

  def_param_group :journals_all do
    param_group :journals_data
    param :timestamp, :undef, :desc => "Timestamp for Journal Entry [DateTime(UTC)]", :required => false
  end

  acts_as_token_authentication_handler_for User

  before_action :authenticate_user!
  before_action :set_journal, only: [:show, :edit, :update, :destroy]
  before_action :set_lookback_period, only: [:index]

  after_action :verify_authorized,  except: [:index]
  #after_filter :verify_policy_scoped, only: [:index]

  respond_to :html, :js, :json
  
  # GET /journals
  # GET /journals.json
  api! "Show Journal Entries"
  def index
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      @journals = Journal.where(user_id: current_user.id)
      skip_authorization
    elsif @user != nil
      @journals = Journal.where(user_id: @user.id)
      if @user.id == current_user.id
        skip_authorization
      elsif current_user.is? :pro
        client_id = @user.id
        if current_user.clients.include? client_id
          skip_authorization
        else
          authorize @journals
        end
      elsif current_user.is? :superuser
        skip_authorization
      end
    else
      authorize @journals
    end

    respond_to do |format|
      format.html
      format.js
      format.json { render :json => @journals, status: 200 }
    end
  end

  # GET /journals/1
  # GET /journals/1.json
  def show
    authorize @journal

    respond_to do |format|
      format.html
      format.js
      format.json { render :json =>  @journal, status: 200 }
    end
  end

  # GET /journals/new
  def new
    @user = User.find_by_id(params[:user_id])
    $capture_source = params[:capture_source]

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @journals
      end
    end

    @journal= Journal.new

    respond_to do |format|
      format.html { render :nothing => true }
      format.js
      format.json { render :json =>  @journal, status: 200 }
    end
  end

  # GET /journals/1/edit
  api! "Edit Journal Entry"
  param_group :journals_all
  def edit
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @journals
      end
    end

    respond_to do |format|
      format.html { render :nothing => true }
      format.js
      format.json { render :json =>  @journal, status: 200 }
    end
  end

  # POST /journals
  # POST /journals.json
  api! "Create Journal Entry"
  param_group :journals_data
  def create
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @journals
      end
    end

    @journal = Journal.new(journal_params)
    @journal.user_id = current_user.id

    if $capture_source == 'journal'
      d = $capture_date
      t = Time.now
      dt = DateTime.new(d.year, d.month, d.day, t.hour, t.min, t.sec, t.zone)

      @journal.timestamp = dt
    else
      @journal.timestamp = DateTime.now.in_time_zone
    end
    
    respond_to do |format|
      if @journal.save
        track_journal_created
        current_user.scorecard.update_scorecard('journals')
        flash.now[:success] = "Journal was successfully tracked."
        format.js { render status: :created }
        format.json { render :json => @journal, status: :created }
      else
        flash.now[:error] = 'Journal Entry was not tracked... Try again???'
        format.js   { render json: @journal.errors, status: :unprocessable_entity }
        format.json { render json: @journal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /journals/1
  # PATCH/PUT /journals/1.json
  api! "Update Journal Entry"
  param_group :journals_all
  def update
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @journals
      end
    end

    respond_to do |format|
      if @journal.update(journal_params)
        track_journal_updated

        flash.now[:success] = "Journal Entry was successfully updated."
        format.js
        format.json { render :json => @journal, status: :created }
      else
        flash.now[:error] = "Journal Entry was not updated... Try again???"
        format.js   { render json: @journal.errors, status: :unprocessable_entity }
        format.json { render json: @journal.errors, status: :unprocessable_entity }
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
        authorize @journals
      end
    end

    @journal = Journal.find(params[:journal_id])
  end

  # DELETE /journals/1
  # DELETE /journals/1.json
  api! "Delete Journal Entry"
  def destroy
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @journals
      end
    end

    @journal.destroy
    track_journal_deleted
    
    respond_to do |format|
      flash.now[:success] = "Journal Entry was successfully deleted."
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
        authorize @journals
      end
    end

    $current_capture_screen = "Journal"

    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_journal
      @journal = Journal.find(params[:id])
    end

    def set_lookback_period
      if(params.has_key?(:journal_lookback_period))
        @journal_lookback_period = params[:journal_lookback_period]
      else
        @journal_lookback_period = DEFAULT_LOOKBACK_PERIOD
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def journal_params
      params.fetch(:journal, {}).permit(:journal_entry, :timestamp, :journal_lookback_period, :capture_source)
    end

    def track_journal_created
      # Track Journal Creation for Segment.io Analytics
      Analytics.track(
        user_id: @journal.user_id,
        event: 'Created Journal Entry',
        properties: {
          journal_id: @journal.id,
          timestamp: @journal.timestamp
        }
      )
    end

    def track_journal_updated
      # Track Journal Update for Segment.io Analytics
      Analytics.track(
        user_id: @journal.user_id,
        event: 'Updated Journal Entry',
        properties: {
          journal_id: @journal.id,
          timestamp: @journal.timestamp
        }
      )
    end

    def track_journal_deleted
      # Track Journal Deletion for Segment.io Analytics
      Analytics.track(
        user_id: @journal.user_id,
        event: 'Deleted Journal Entry',
        properties: {
        }
      )
    end
end