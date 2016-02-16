class PassiveActivitiesController < ApplicationController
  before_action :set_passive_activity, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @passive_activities = PassiveActivity.all
    respond_with(@passive_activities)
  end

  def show
    respond_with(@passive_activity)
  end

  def new
    @passive_activity = PassiveActivity.new
    respond_with(@passive_activity)
  end

  def edit
  end

  def create
    @passive_activity = PassiveActivity.new(passive_activity_params)
    @passive_activity.save
    respond_with(@passive_activity)
  end

  def update
    @passive_activity.update(passive_activity_params)
    respond_with(@passive_activity)
  end

  def destroy
    @passive_activity.destroy
    respond_with(@passive_activity)
  end

  private
    def set_passive_activity
      @passive_activity = PassiveActivity.find(params[:id])
    end

    def passive_activity_params
      params.require(:passive_activity).permit(:passive_data_point_id, :activity_type, :value, :unit, :kcal_burned_value, :kcal_burned_unit, :step_count)
    end
end
