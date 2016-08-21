class DevicesController < ApplicationController
  acts_as_token_authentication_handler_for User
  before_action :authenticate_user!
  before_action :set_device, only: [:show, :edit, :update, :destroy]

  after_action :verify_authorized, except: [:index]

  respond_to :html, :json

  # GET /devices
  # GET /devices.json
  def index
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      @devices = Device.where(user_id: current_user.id)
      skip_authorization
    elsif @user != nil
      @devices = Device.where(user_id: @user.id)
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @devices
      end
    end

    respond_to do |format|
      format.html
      format.json { render json: @devices, status: 200 }
    end
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
    authorize @device
  end

  # GET /devices/new
  def new
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @devices
      end
    end

    @device = Device.new
  end

  # GET /devices/1/edit
  def edit
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @devices
      end
    end

    respond_to do |format|
      format.html
      format.json { render :json => @device, status: 200 }
    end
  end

  # POST /devices
  # POST /devices.json
  def create
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @devices
      end
    end

    @device = Device.new(device_params)
    @device.user_id = current_user.id

    respond_to do |format|
      if @device.save
        track_device_created
        flash.now[:success] = 'Device was successfully created.'
        format.html { redirect_to devices_path }
        format.json { render json: @device, status: :created }
      else
        flash.now[:error] = 'Device was not created... Try again???'
        format.html { render :new }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /devices/1
  # PATCH/PUT /devices/1.json
  def update
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @devices
      end
    end

    respond_to do |format|
      if @device.update(device_params)
        track_device_updated
        flash.now[:success] = 'Device was successfully updated.'
        format.html { redirect_to @device, notice: 'Device was successfully updated.' }

        format.json { render json: @device, status: 200 }
      else
        flash.now[:error] = 'Device was not updated... Try again???'
        format.html { render :edit }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      skip_authorization
    elsif @user != nil
      if @user.id == current_user.id
        skip_authorization
      else
        authorize @devices
      end
    end

    respond_to do |format|
      if @device.destroy
        track_device_deleted
        flash[:success] = 'Device was successfully deleted.'
        format.html { redirect_to devices_path }
        format.json { head :no_content }
      else
        flash[:error] = 'Device was not deleted... Try again???'
        format.html { redirect devices_path }
        format.json { render json: @devices.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_device
    @device = Device.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def device_params
    params.fetch(:device, {}).permit(:enabled, :token, :user_id, :platform)
  end

  def track_device_created
    # Track Device Creation for Segment.io Analytics
    Analytics.track(
      user_id: current_user.id,
      event: 'Device Entry Created',
      properties: {
        device_id: @device.id,
        device_enabled: @device.enabled,
        device_user_id: @device.user_id,
        device_platform: @device.platform
      }
    )
  end

  def track_device_updated
    # Track Device Update for Segment.io Analytics
    Analytics.track(
      user_id: current_user.id,
      event: 'Device Entry Updated',
      properties: {
        device_id: @device.id,
        device_enabled: @device.enabled,
        device_user_id: @device.user_id,
        device_platform: @device.platform
      }
    )
  end

  def track_device_deleted
    # Track Device Deletion for Segment.io Analytics
    Analytics.track(
      user_id: current_user.id,
      event: 'Device Entry Deleted',
      properties: {
      }
    )
  end
end