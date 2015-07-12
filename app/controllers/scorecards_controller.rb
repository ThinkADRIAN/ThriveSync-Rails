class ScorecardsController < ApplicationController
  acts_as_token_authentication_handler_for User

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  #load_and_authorize_resource
  check_authorization

  before_action :set_scorecard, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  respond_to :html, :js, :json, :xml

  def index
    authorize! :manage, Scorecard
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      @scorecards = Scorecard.where(user_id: current_user.id)
    elsif @user != nil
      @scorecards = Scorecard.where(user_id: @user.id)
    end

    current_user.scorecard.update_goals

    respond_to do |format|
      format.html
      format.json { render :json => @scorecards, status: 200 }
    end
  end

  def show
    authorize! :manage, Scorecard
    respond_with(@scorecard)
  end

  def new
    authorize! :manage, Scorecard
    @scorecard = Scorecard.new
    respond_with(@scorecard)
  end

  def edit
    authorize! :manage, Scorecard
  end

  def create
    authorize! :manage, Scorecard
    @scorecard = Scorecard.new(scorecard_params)
    @scorecard.save
    respond_with(@scorecard)
  end

  def update
    authorize! :manage, Scorecard
    
    respond_to do |format|
      if @scorecard.update(scorecard_params)
        @scorecard.update_goals
        track_scorecard_updated

        flash.now[:success] = "Scorecard was successfully updated."
        format.html { redirect_to scorecards_url, notice: 'Scorecard was successfully updated.' }
        format.js
        format.json { render :json => @scorecard, status: :created }
      else
        flash.now[:error] = 'Scorecard was not updated... Try again???'
        format.js   { render json: @scorecard.errors, status: :unprocessable_entity }
        format.json { render json: @scorecard.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize! :manage, Scorecard
    @scorecard.destroy
    respond_with(@scorecard)
  end

  private
    def set_scorecard
      @scorecard = Scorecard.find(params[:id])
    end

    def scorecard_params
      params.fetch(:scorecard, {}).permit(:checkin_goal)
    end

    def track_scorecard_updated
      # Track Scorecard Update for Segment.io Analytics
      Analytics.track(
        user_id: @scorecard.user_id,
        event: 'Updated Scorecard',
        properties: {
          scorecard_id: @scorecard.id,
          checkin_goal: @scorecard.checkin_goal,
          updated_at: @scorecard.updated_at
        }
      )
    end
end
