class SleepsController < ApplicationController
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  #load_and_authorize_resource
  check_authorization

  before_action :set_sleep, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_rails_user!

  respond_to :js

  Time.zone = 'EST'
  
  # GET /sleeps
  # GET /sleeps.json
  def index
    authorize! :manage, Sleep
    authorize! :read, Sleep
    @rails_user = RailsUser.find_by_id(params[:rails_user_id])
    if @rails_user == nil
      @sleeps = Sleep.where(user_id: current_rails_user.id)
    elsif @rails_user != nil
      @sleeps = Sleep.where(user_id: @rails_user.id)
    end

    respond_to do |format|
      format.html
      format.js
      format.json { render :json => @sleeps, status: 200 }
      format.xml { render :xml => @sleeps, status: 200 }
    end
  end

  # GET /sleeps/1
  # GET /sleeps/1.json
  def show
    authorize! :manage, Sleep
    authorize! :read, Sleep

    respond_to do |format|
      format.js
      format.json { render :json =>  @sleep, status: 200 }
      format.xml { render :xml => @sleep, status: 200 }
    end
  end

  # GET /sleeps/new
  def new
    authorize! :manage, Sleep
    @sleep= Sleep.new
  end

  # GET /sleeps/1/edit
  def edit
    authorize! :manage, Sleep
  end

  # POST /sleeps
  # POST /sleeps.json
  def create
    authorize! :manage, Sleep
    @sleep = Sleep.new(sleep_params)
    @sleep.user_id = current_rails_user.id
    @sleep.time = (@sleep.finish_time.to_i - @sleep.start_time.to_i) / 3600
    
    respond_to do |format|
      if @sleep.save
        flash.now[:success] = 'Sleep Entry was successfully tracked.'
        format.js 
        format.json { render :show, status: :created, location: sleeps_url }
      else
        format.js { render json: @sleep.errors, status: :unprocessable_entity }
        format.json { render json: @sleep.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sleeps/1
  # PATCH/PUT /sleeps/1.json
  def update
    authorize! :manage, Sleep

    respond_to do |format|
      if @sleep.update(sleep_params)
        @sleep.time = (@sleep.finish_time.to_i - @sleep.start_time.to_i) / 3600
        @sleep.save

        flash.now[:success] = 'Sleep Entry was successfully updated.'
        format.js
        format.json { render :show, status: :ok, location: sleeps_url }
      else
        flash.now[:error] = 'Sleep Entry was not updated... Try again???'
        format.js { render json: @sleep.errors, status: :unprocessable_entity }
        format.json { render json: @sleep.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete
    authorize! :manage, Sleep
    @sleep = Sleep.find(params[:sleep_id])
  end

  # DELETE /sleeps/1
  # DELETE /sleeps/1.json
  def destroy
    authorize! :manage, Sleep
    @sleep.destroy

    respond_to do |format|
      flash.now[:success] = 'Sleep Entry was successfully removed.'
      format.js
      format.json { head :no_content }
    end
  end

  def cancel
    authorize! :manage, Sleep
    authorize! :read, Sleep
    
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sleep
      @sleep = Sleep.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sleep_params
      params.require(:sleep).permit(:start_time, :finish_time, :quality)
    end
end