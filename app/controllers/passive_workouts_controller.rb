class PassiveWorkoutsController < ApplicationController
  before_action :set_passive_workout, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @passive_workouts = PassiveWorkout.all
    respond_with(@passive_workouts)
  end

  def show
    respond_with(@passive_workout)
  end

  def new
    @passive_workout = PassiveWorkout.new
    respond_with(@passive_workout)
  end

  def edit
  end

  def create
    @passive_workout = PassiveWorkout.new(passive_workout_params)
    @passive_workout.save
    respond_with(@passive_workout)
  end

  def update
    @passive_workout.update(passive_workout_params)
    respond_with(@passive_workout)
  end

  def destroy
    @passive_workout.destroy
    respond_with(@passive_workout)
  end

  private
    def set_passive_workout
      @passive_workout = PassiveWorkout.find(params[:id])
    end

    def passive_workout_params
      params.require(:passive_workout).permit(:passive_data_point_id, :workout_type, :kcal_burned_value, :kcal_burned_unit, :distance_value, :distance_unit)
    end
end
