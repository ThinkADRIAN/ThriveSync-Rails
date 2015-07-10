class JournalsController < ApplicationController
  acts_as_token_authentication_handler_for User

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  before_action :set_journal, only: [:show, :edit, :update, :destroy]
  before_action :set_lookback_period, only: [:index]
  before_action :authenticate_user!

  after_filter :verify_authorized,  except: [:index]
  after_filter :verify_policy_scoped, only: [:index]

  respond_to :html, :js, :json, :xml
  
  # GET /journals
  # GET /journals.json
  def index
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      @journals = Journal.where(user_id: current_user.id)
      authorize @journals, :index_self?
    elsif @user != nil
      @journals = Journal.where(user_id: @user.id)
      if @user.id == current_user.id
        authorize @journals, :index_self?
      else
        authorize @journals
      end
    end

    @journals = policy_scope(@journals)

    respond_to do |format|
      format.html
      format.js
      format.json { render :json => @journals, status: 200 }
      format.xml { render :xml => @journals, status: 200 }
    end
  end

  # GET /journals/1
  # GET /journals/1.json
  def show
    authorize! :manage, Journal
    authorize! :read, Journal

    respond_to do |format|
      format.js
      format.json { render :json =>  @journal, status: 200 }
      format.xml { render :xml => @journal, status: 200 }
    end
  end

  # GET /journals/new
  def new
    authorize! :manage, Journal

    @journal= Journal.new
  end

  # GET /journals/1/edit
  def edit
    authorize! :manage, Journal
  end

  # POST /journals
  # POST /journals.json
  def create
    authorize! :manage, Journal

    @journal = Journal.new(journal_params)
    @journal.user_id = current_user.id
    @journal.update_attribute(:timestamp, DateTime.now.in_time_zone)
    
    respond_to do |format|
      if @journal.save
        track_journal_created
        current_user.scorecard.update_scorecard('journals')
        flash.now[:success] = "Journal was successfully tracked."
        format.js
        format.json { render :json => @journal, status: :created }
      else
        format.js   { render json: @journal.errors, status: :unprocessable_entity }
        format.json { render json: @journal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /journals/1
  # PATCH/PUT /journals/1.json
  def update
    authorize! :manage, Journal

    respond_to do |format|
      if @journal.update(journal_params)
        track_journal_updated
        flash.now[:success] = "Journal Entry was successfully updated."
        format.js
        format.json { render :json => @journal, status: :created }
      else
        flash.now[:error] = 'Journal Entry was not updated... Try again???'
        format.js   { render json: @journal.errors, status: :unprocessable_entity }
        format.json { render json: @journal.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete
    authorize! :manage, Journal

    @journal = Journal.find(params[:journal_id])
  end

  # DELETE /journals/1
  # DELETE /journals/1.json
  def destroy
    authorize! :manage, Journal

    @journal.destroy
    track_journal_deleted
    
    respond_to do |format|
      flash.now[:success] = "Journal Entry was successfully deleted."
      format.js 
      format.json { head :no_content }
    end
  end

  def cancel
    authorize! :manage, Journal
    authorize! :read, Journal

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
      params.fetch(:journal, {}).permit(:journal_entry, :timestamp, :journal_lookback_period)
    end

    def track_journal_created
      # Track Journal Creation for Segment.io Analytics
      Analytics.track(
        user_id: @journal.user_id,
        event: 'Created Journal Entry',
        properties: {
          journal_id: @journal.id,
          journal_entry: @journal.journal_entry,
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
          journal_entry: @journal.journal_entry,
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