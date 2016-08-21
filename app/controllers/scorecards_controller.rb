class ScorecardsController < ApplicationController
  resource_description do
    name 'Scorecards'
    short 'Scorecards'
    desc <<-EOS
      == Long description
        Store game data for Thrivers in a Scorecard
    EOS

    api_base_url ""
    formats ['html', 'json']
  end

  def_param_group :scorecards_data do
    param :checkin_goal, :number, :desc => "Checkin Goal [Number]", :required => true
  end

  def_param_group :destroy_scorecards_data do
    param :id, :number, :desc => "Id of Scorecard to Delete [Number]", :required => true
  end

  acts_as_token_authentication_handler_for User

  before_action :authenticate_user!
  before_action :set_scorecard, only: [:show, :edit, :update, :destroy]

  after_action :verify_authorized

  respond_to :html, :json

  # GET /scorecards
  # GET /scorecards.json
  api! "Show Scorecards"

  def index
    authorize :review, :index?
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      @scorecards = Scorecard.where(user_id: current_user.id)
    elsif @user != nil
      @scorecards = Scorecard.where(user_id: @user.id)
    end

    current_user.scorecard.refresh_scorecard(Time.zone.now)

    respond_to do |format|
      format.html
      format.json { render :json => @scorecards, status: 200 }
    end
  end

  # GET /scorecards/1
  # GET /scorecards/1.json
  def show
    authorize :review, :show?

    respond_to do |format|
      format.html
      format.json { render :json => @scorecard, status: 200 }
    end
  end

  # GET /scoreards/new
  def new
    authorize :review, :new?
    @scorecard = Scorecard.new

    respond_to do |format|
      format.html
      format.json { render :json => @scorecard, status: 200 }
    end
  end

  # GET /scorecards/1/edit
  api! "Edit Scorecard"

  def edit
    authorize :review, :edit?

    respond_to do |format|
      format.html
      format.json { render :json => @scorecard, status: 200 }
    end
  end

  # POST /scorecards
  # POST /scorecards.json
  api! "Create Scorecard"
  param_group :scorecards_data

  def create
    authorize :review, :create?
    @scorecard = Scorecard.new(scorecard_params)

    respond_to do |format|
      if @scorecard.save
        track_scorecard_created
        flash[:success] = 'Scorecard was successfully created.'
        format.html { redirect_to scorecards_path }
        format.json { render json: @scorecard, status: :created }
      else
        flash[:error] = 'Scorecard was not created... Try again???'
        format.html { render :new }
        format.json { render json: @scorecards.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scorecards/1
  # PATCH/PUT /scorecards/1.json
  api! "Update Scorecard"
  param_group :scorecards_data

  def update
    authorize :review, :update?

    respond_to do |format|
      if @scorecard.update(scorecard_params)
        @scorecard.update_goals
        track_scorecard_updated

        flash.now[:success] = 'Scorecard was successfully updated.'
        format.html { redirect_to scorecards_url, notice: 'Scorecard was successfully updated.' }
        format.js
        format.json { render :json => @scorecard, status: :created }
      else
        flash.now[:error] = 'Scorecard was not updated... Try again???'
        format.js { render json: @scorecard.errors, status: :unprocessable_entity }
        format.json { render json: @scorecard.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scorecards/1
  # DELETE /scorecards/1.json
  api! "Delete Scorecard"
  param_group :destroy_scorecards_data

  def destroy
    authorize :review, :destroy?

    respond_to do |format|
      if @scorecard.destroy
        track_scorecard_deleted
        flash[:success] = 'Scorecard was successfully deleted.'
        format.html { redirect_to scorecards_path }
        format.json { head :no_content }
      else
        flash[:error] = 'Scorecard was not deleted... Try again???'
        format.html { redirect scorecards_path }
        format.json { render json: @scorecards.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def set_scorecard
    @scorecard = Scorecard.find(params[:id])
  end

  def scorecard_params
    params.fetch(:scorecard, {}).permit(:checkin_goal)
  end

  def track_scorecard_created
    # Track Scorecard Creation for Segment.io Analytics
    Analytics.track(
      user_id: current_user.id,
      event: 'Scorecard Created',
      properties: {
        scorecard_id: @scorecard.id,
        checkin_goal: @scorecard.checkin_goal,
        updated_at: @scorecard.updated_at,
        scorecard_user_id: @scorecard.user_id
      }
    )
  end

  def track_scorecard_updated
    # Track Scorecard Update for Segment.io Analytics
    Analytics.track(
      user_id: current_user.id,
      event: 'Scorecard Updated',
      properties: {
        scorecard_id: @scorecard.id,
        checkin_goal: @scorecard.checkin_goal,
        updated_at: @scorecard.updated_at,
        scorecard_user_id: @scorecard.user_id
      }
    )
  end

  def track_scorecard_deleted
    # Track Scorecard Deletion for Segment.io Analytics
    Analytics.track(
      user_id: @scorecard.user_id,
      event: 'Scorecard Deleted',
      properties: {
      }
    )
  end
end
