class PassiveDataPointsController < ApplicationController
  resource_description do
    short 'Passive Data Point Entries'
    desc <<-EOS
      == Long description
        Passive Data Point Entries include:
          Required Fields:
            user_id: integer
            source_uuid: string
            creation_date_time: datetime
            schema_namespace: string
            schema_name: string
            schema_version: string
          Optional Fields:
            was_user_entered: boolean
            timezone: string
            external_uuid: string
            effective_date_time: datetime

      ===Sample JSON Output:
          {
            "passive_data_point": {
              "id": 1,
              "user_id": 3,
              "was_user_entered": true,
              "timezone": "EST",
              "source_uuid": "abc1234",
              "external_uuid": "xyz7890",
              "creation_date_time": "2016-02-15 08:35:00 -0500",
              "schema_namespace": "test_namespace",
              "schema_name": "test_name",
              "schema_version": "test_version",
              "effective_date_time": "2016-02-15 09:34:00 -0500"
            }
          }
    EOS
    api_base_url ""
    formats ['html', 'json']
  end

  def_param_group :passive_data_points_data do
    param :passive_data_point, Hash, :desc => "Passive Data Point", :required => false do
      param :source_uuid, :undef, :desc => "Source Identification of Passive Data Point [String]", :required => true
      param :creation_date_time, :undef, :desc => "Creation Date as defined from Source [Timestamp]", :required => false
      param :schema_namespace, :undef, :desc => "Schema Namespace [String]", :required => true
      param :schema_name, :undef, :desc => "Schema Name [String]", :required => true
      param :schema_version, :undef, :desc => "Schema Version [String]", :required => true
      param :effective_date_time, :undef, :desc => "Effective Date Time [Timestamp]", :required => false
    end
  end

  def_param_group :passive_data_points_all do
    param_group :passive_data_points_data
    param :was_user_entered, :undef, :desc => "User Entered Flag [Boolean]", :required => false
    param :timezone, :undef, :desc => "Timezone [String]", :required => false
    param :external_uuid, :undef, :desc => "External Source Identification of Passive Data Point [String]", :required => false
  end

  def_param_group :destroy_passive_data_point_data do
    param :id, :number, :desc => "Id of Passive Data Point to Delete [Number]", :required => true
  end

  acts_as_token_authentication_handler_for User

  before_action :set_passive_data_point, only: [:show, :edit, :update, :destroy]

  after_action :verify_authorized, except: [:index]

  respond_to :html, :json

  # GET /passive_data_points
  # GET /passive_data_points.json
  api! "Show Passive Data Points"

  def index
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      @passive_data_points = PassiveDataPoint.where(user_id: current_user.id)
      skip_authorization
    elsif @user != nil
      @passive_data_points = PassiveDataPoint.where(user_id: @user.id)
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @passive_data_points
      end
    end

    respond_to do |format|
      format.html
      format.json { render :json => @passive_data_points, status: 200 }
    end
  end

  # GET /passive_data_points/1
  # GET /passive_data_points/1.json
  def show
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @passive_data_points
      end
    end

    respond_to do |format|
      format.html
      format.json { render :json => @passive_data_point, status: 200 }
    end
  end

  # GET /passive_data_points/new
  def new
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @passive_data_points
      end
    end

    @passive_data_point = PassiveDataPoint.new

    respond_to do |format|
      format.html
      format.json { render :json => @passive_data_point, status: 200 }
    end
  end

  # GET /passive_data_points/1/edit
  def edit
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @passive_data_points
      end
    end

    respond_to do |format|
      format.html
      format.json { render :json => @passive_data_point, status: 200 }
    end
  end

  # POST /passive_data_points
  # POST /passive_data_points.json
  api! "Create Passive Data Point"
  param_group :passive_data_points_data

  def create
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @passive_data_points
      end
    end

    @passive_data_point = PassiveDataPoint.new(passive_data_point_params)
    @passive_data_point.user_id = current_user.id

    respond_to do |format|
      if @passive_data_point.save
        track_passive_data_point_created
        flash[:success] = 'Passive Data Point was successfully created.'
        format.html { redirect_to passive_data_points_path }
        format.json { render json: @passive_data_point, status: :created }
      else
        flash[:error] = 'Passive Data Point was not created... Try again???'
        format.html { render :new }
        format.json { render json: @passive_data_points.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /passive_data_points/1
  # PATCH/PUT /passive_data_points/1.json
  api! "Update Passive Data Point"
  param_group :passive_data_points_data

  def update
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @passive_data_points
      end
    end

    respond_to do |format|
      if @passive_data_point.update(passive_data_point_params)
        track_passive_data_point_updated

        flash.now[:success] = 'Passive Data Point was successfully updated.'
        format.html { redirect_to passive_data_points_url, notice: 'Passive Data Point was successfully updated.' }
        format.json { render :json => @passive_data_point, status: :created }
      else
        flash.now[:error] = 'Passive Data Point was not updated... Try again???'
        format.json { render json: @passive_data_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /passive_data_points/1
  # DELETE /passive_data_points/1.json
  api! "Delete Passive Data Point"
  param_group :destroy_passive_data_point_data

  def destroy
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @passive_data_points
      end
    end

    respond_to do |format|
      if @passive_data_point.destroy
        track_passive_data_point_deleted
        flash[:success] = 'Passive Data Point was successfully deleted.'
        format.html { redirect_to passive_data_points_path }
        format.json { head :no_content }
      else
        flash[:error] = 'Passive Data Point was not deleted... Try again???'
        format.html { redirect passive_data_points_path }
        format.json { render json: @passive_data_points.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_passive_data_point
      @passive_data_point = PassiveDataPoint.find(params[:id])
    end

    def passive_data_point_params
      params.fetch(:passive_data_point, {}).permit(:user_id, :was_user_entered, :timezone,  :source_uuid, :external_uuid, :creation_date_time, :schema_namespace, :schema_name,  :schema_version, :effective_date_time, effective_time_intervals_attributes: [:id, :start_date_time, :end_date_time, :_destroy])
    end

  def track_passive_data_point_created
    # Track Passive Data Point Creation for Segment.io Analytics
    Analytics.track(
      user_id: current_user.id,
      event: 'Passive Data Point Created',
      properties: {
        passive_data_point_id: @passive_data_point.id,
        was_user_entered: @passive_data_point.was_user_entered,
        timezone: @passive_data_point.timezone,
        source_uuid: @passive_data_point.source_uuid,
        external_uuid: @passive_data_point.external_uuid,
        creation_date_time: @passive_data_point.creation_date_time,
        schema_namespace: @passive_data_point.schema_namespace,
        schema_name: @passive_data_point.schema_name,
        schema_version: @passive_data_point.schema_version,
        effective_date_time: @passive_data_point.effective_date_time,
        updated_at: @passive_data_point.updated_at,
        passive_data_point_user_id: @passive_data_point.user_id
      }
    )
  end

  def track_passive_data_point_updated
    # Track Passive Data Point Update for Segment.io Analytics
    Analytics.track(
      user_id: current_user.id,
      event: 'Passive Data Point Updated',
      properties: {
        passive_data_point_id: @passive_data_point.id,
        was_user_entered: @passive_data_point.was_user_entered,
        timezone: @passive_data_point.timezone,
        source_uuid: @passive_data_point.source_uuid,
        external_uuid: @passive_data_point.external_uuid,
        creation_date_time: @passive_data_point.creation_date_time,
        schema_namespace: @passive_data_point.schema_namespace,
        schema_name: @passive_data_point.schema_name,
        schema_version: @passive_data_point.schema_version,
        effective_date_time: @passive_data_point.effective_date_time,
        updated_at: @passive_data_point.updated_at,
        passive_data_point_user_id: @passive_data_point.user_id
      }
    )
  end

  def track_passive_data_point_deleted
    # Track Passive Data Point Deletion for Segment.io Analytics
    Analytics.track(
      user_id: @passive_data_point.user_id,
      event: 'Passive Data Point Deleted',
      properties: {
      }
    )
  end
end
