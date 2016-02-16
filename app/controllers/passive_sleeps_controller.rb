class PassiveSleepsController < ApplicationController
  before_action :set_passive_sleep, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @passive_sleeps = PassiveSleep.all
    respond_with(@passive_sleeps)
  end

  def show
    respond_with(@passive_sleep)
  end

  def new
    @passive_sleep = PassiveSleep.new
    respond_with(@passive_sleep)
  end

  def edit
  end

  def create
    @passive_sleep = PassiveSleep.new(passive_sleep_params)
    @passive_sleep.save
    respond_with(@passive_sleep)
  end

  def update
    @passive_sleep.update(passive_sleep_params)
    respond_with(@passive_sleep)
  end

  def destroy
    @passive_sleep.destroy
    respond_with(@passive_sleep)
  end

  private
    def set_passive_sleep
      @passive_sleep = PassiveSleep.find(params[:id])
    end

    def passive_sleep_params
      params.require(:passive_sleep).permit(:passive_data_point_id, :category_type, :category_value, :value, :unit)
    end
end
