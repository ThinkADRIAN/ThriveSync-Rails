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

  Time.zone = 'EST'

  def index
    authorize! :manage, Scorecard
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      @scorecard = Scorecard.where(user_id: current_user.id)
    elsif @user != nil
      @scorecard = Scorecard.where(user_id: @user.id)
    end

    respond_to do |format|
      format.html
      format.json { render :json => @scorecard, status: 200 }
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
    @scorecard.update(scorecard_params)
    respond_with(@scorecard)
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
      params.fetch(:scorecard, {}).permit(:checkin_count, :perfect_checkin_count, :last_checkin_date, :streak_count, :streak_record, :moods_score, :sleeps_score, :self_cares_score, :journals_score)
    end
end
