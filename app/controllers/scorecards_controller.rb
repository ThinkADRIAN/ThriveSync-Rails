class ScorecardsController < ApplicationController
  before_action :set_scorecard, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @scorecards = Scorecard.all
    respond_with(@scorecards)
  end

  def show
    respond_with(@scorecard)
  end

  def new
    @scorecard = Scorecard.new
    respond_with(@scorecard)
  end

  def edit
  end

  def create
    @scorecard = Scorecard.new(scorecard_params)
    @scorecard.save
    respond_with(@scorecard)
  end

  def update
    @scorecard.update(scorecard_params)
    respond_with(@scorecard)
  end

  def destroy
    @scorecard.destroy
    respond_with(@scorecard)
  end

  private
    def set_scorecard
      @scorecard = Scorecard.find(params[:id])
    end

    def scorecard_params
      params.require(:scorecard).permit(:checkin_count, :perfect_checkin_count, :last_checkin_date, :streak_count, :streak_record, :moods_score, :sleeps_score, :self_cares_score, :journals_score)
    end
end
