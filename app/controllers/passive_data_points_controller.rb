class PassiveDataPointsController < ApplicationController
  before_action :set_passive_data_point, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @passive_data_points = PassiveDataPoint.all
    respond_with(@passive_data_points)
  end

  def show
    respond_with(@passive_data_point)
  end

  def new
    @passive_data_point = PassiveDataPoint.new
    respond_with(@passive_data_point)
  end

  def edit
  end

  def create
    @passive_data_point = PassiveDataPoint.new(passive_data_point_params)
    @passive_data_point.save
    respond_with(@passive_data_point)
  end

  def update
    @passive_data_point.update(passive_data_point_params)
    respond_with(@passive_data_point)
  end

  def destroy
    @passive_data_point.destroy
    respond_with(@passive_data_point)
  end

  private
    def set_passive_data_point
      @passive_data_point = PassiveDataPoint.find(params[:id])
    end

    def passive_data_point_params
      params.require(:passive_data_point).permit(:user_id, :integer, :was_user_entered, :boolean, :timezone, :string, :source_uuid, :string, :external_uuid, :string, :creation_date_time, :date, :schema_namespace, :string, :schema_name, :string, :schema_version, :string)
    end
end
