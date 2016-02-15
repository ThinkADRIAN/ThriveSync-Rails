class EffectiveTimeIntervalsController < ApplicationController
  before_action :set_effective_time_interval, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @effective_time_intervals = EffectiveTimeInterval.all
    respond_with(@effective_time_intervals)
  end

  def show
    respond_with(@effective_time_interval)
  end

  def new
    @effective_time_interval = EffectiveTimeInterval.new
    respond_with(@effective_time_interval)
  end

  def edit
  end

  def create
    @effective_time_interval = EffectiveTimeInterval.new(effective_time_interval_params)
    @effective_time_interval.save
    respond_with(@effective_time_interval)
  end

  def update
    @effective_time_interval.update(effective_time_interval_params)
    respond_with(@effective_time_interval)
  end

  def destroy
    @effective_time_interval.destroy
    respond_with(@effective_time_interval)
  end

  private
    def set_effective_time_interval
      @effective_time_interval = EffectiveTimeInterval.find(params[:id])
    end

    def effective_time_interval_params
      params.require(:effective_time_interval).permit(:passive_data_point_id, :start_date_time, :end_date_time)
    end
end
