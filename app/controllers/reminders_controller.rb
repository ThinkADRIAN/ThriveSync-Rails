class RemindersController < ApplicationController
  resource_description do
    name 'Reminders'
    short 'Reminders'
    desc <<-EOS
      == Long description
        Reminders are used for timed notifications that can re-engage the Thriver.
      EOS

    api_base_url ""
    formats ['html', 'json']
  end

  def_param_group :reminders_data do
    param :message, :undef, :desc => "Message [String]", :required => false
    param :sunday_enabled, :bool, :desc => "Sunday Enabled [Boolean]", :required => false
    param :monday_enabled, :bool, :desc => "Monday Enabled [Boolean]", :required => false
    param :tuesday_enabled, :bool, :desc => "Tuesday Enabled [Boolean]", :required => false
    param :wednesday_enabled, :bool, :desc => "Wednesday Enabled [Boolean]", :required => false
    param :thursday_enabled, :bool, :desc => "Thursday Enabled [Boolean]", :required => false
    param :friday_enabled, :bool, :desc => "Friday Enabled [Boolean]", :required => false
    param :saturday_enabled, :bool, :desc => "Saturday Enabled [Boolean]", :required => false
    param :alert_time, :undef, :desc => "Alert Time [DateTime]", :required => false
  end

  def_param_group :destroy_reminders_data do
    param :id, :number, :desc => "Reminder to Delete [Number]", :required => true
  end

  acts_as_token_authentication_handler_for User

  before_action :authenticate_user!
  before_action :set_reminder, only: [:show, :edit, :update, :destroy]
  
  after_action :verify_authorized

  respond_to :html, :json

  # GET /reminders
  # GET /reminders.json
  api! "Show Reminders"
  def index
    authorize :reminder, :index?
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      @reminders = Reminder.where(user_id: current_user.id)
    elsif @user != nil
      @reminders = Reminder.where(user_id: @user.id)
    end

    respond_to do |format|
      format.html
      format.json { render json: @reminders, status: 200 }
    end
  end

  # GET /reminders/1
  # GET /reminders/1.json
  def show
    authorize :reminder, :show?

    respond_to do |format|
      format.html
      format.json { render json: @reminder, status: 200 }
    end
  end

  # GET /reminders/new
  def new
    authorize :reminder, :new?
    @reminder = Reminder.new

    respond_to do |format|
      format.html
      format.json { render json: @reminder, status: 200 }
    end
  end

  # GET /reminders/1/edit
  def edit
    authorize :reminder, :edit?

    respond_to do |format|
      format.html
      format.json { render json: @reminder, status: 200 }
    end
  end

  # POST /reminders
  # POST /reminders.json
  def create
    authorize :reminder, :create?
    @reminder = Reminder.new(reminder_params)

    respond_to do |format|
      if @reminder.save
        track_reminder_created
        flash.now[:success] = 'Reminder was successfully created.'
        format.html { redirect_to reminders_path }
        format.json { render json: @reminder, status: :created }
      else
        flash.now[:error] = 'Reminder was not created... Try again???'
        format.html { render :new }
        format.json { render json: @reminder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reminders/1
  # PATCH/PUT /reminders/1.json
  api! "Update Reminder"
  param_group :reminders_data
  def update
    authorize :reminder, :update?

    respond_to do |format|
      if @reminder.update(reminder_params)
        track_reminder_updated
        flash.now[:success] = 'Reminder was successfully updated.'
        format.html { redirect_to reminders_path }
        format.json { render json: @reminder, status: 200 }
      else
        flash.now[:error] = 'Reminder was not updated... Try again???'
        format.html { render :edit }
        format.json { render json: @reminder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reminders/1
  # DELETE /reminders/1.json
  api! "Delete Reminder"
  param_group :destroy_reminders_data
  def destroy
    authorize :reminder, :destroy?

    respond_to do |format|
      if @reminder.destroy
        track_reminder_deleted
        flash[:success] = 'Reminder was successfully deleted.'
        format.html { redirect_to reminders_path }
        format.json { head :no_content }
      else
        flash[:error] = 'Reminder was not deleted... Try again???'
        format.html { redirect reminders_path }
        format.json { render json: @reminders.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def set_reminder
    @reminder = Reminder.find(params[:id])
  end

  def reminder_params
    params.fetch(:reminder, {}).permit(:user_id, :message, :sunday_enabled, :monday_enabled, :tuesday_enabled, :wednesday_enabled, :thursday_enabled, :friday_enabled, :saturday_enabled, :alert_time)
  end

  def track_reminder_created
    # Track Reminder Creation for Segment.io Analytics
    Analytics.track(
        user_id: current_user.id,
        event: 'Reminder Created',
        properties: {
            reminder_id: @reminder.id,
            reminder_user_id: @reminder.user_id,
            message: @reminder.message,
            sunday_enabled: @reminder.sunday_enabled,
            monday_enabled: @reminder.monday_enabled,
            tuesday_enabled: @reminder.tuesday_enabled,
            wednesday_enabled: @reminder.wednesday_enabled,
            thursday_enabled: @reminder.thursday_enabled,
            friday_enabled: @reminder.friday_enabled,
            saturday_enabled: @reminder.saturday_enabled,
            alert_time: @reminder.alert_time
        }
    )
  end

  def track_reminder_updated
    # Track Reminder Update for Segment.io Analytics
    Analytics.track(
        user_id: current_user.id,
        event: 'Reminder Updated',
        properties: {
            reminder_id: @reminder.id,
            reminder_user_id: @reminder.user_id,
            message: @reminder.message,
            sunday_enabled: @reminder.sunday_enabled,
            monday_enabled: @reminder.monday_enabled,
            tuesday_enabled: @reminder.tuesday_enabled,
            wednesday_enabled: @reminder.wednesday_enabled,
            thursday_enabled: @reminder.thursday_enabled,
            friday_enabled: @reminder.friday_enabled,
            saturday_enabled: @reminder.saturday_enabled,
            alert_time: @reminder.alert_time
        }
    )
  end

  def track_reminder_deleted
    # Track Reminder Deletion for Segment.io Analytics
    Analytics.track(
        user_id: current_user.id,
        event: 'Reminder Deleted',
        properties: {
        }
    )
  end
end