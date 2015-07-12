class RemindersController < ApplicationController
  acts_as_token_authentication_handler_for User

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  check_authorization

  before_action :set_reminder, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  respond_to :html, :js, :json, :xml

  def index
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      @reminders = Reminder.where(user_id: current_user.id)
    elsif @user != nil
      @reminders = Reminder.where(user_id: @user.id)
    end

    authorize! :manage, Reminder

    respond_to do |format|
      format.html
      format.js
      format.json { render :json => @reminders, status: 200 }
      format.xml { render :xml => @reminders, status: 200 }
    end
  end

  def show
    authorize! :manage, Reminder

    respond_to do |format|
      format.html
      format.js
      format.json { render :json =>  @reminder, status: 200 }
      format.xml { render :xml => @reminder, status: 200 }
    end
  end

  def new
    @reminder = Reminder.new
  end

  def edit
    authorize! :manage, Reminder
  end

  def create
    @reminder = Reminder.new(reminder_params)
    @reminder.save
    respond_with(@reminder)
  end

  def update
    authorize! :manage, Reminder
    @reminder.update(reminder_params)
    respond_with(@reminder)
  end

  def destroy
    @reminder.destroy
    respond_with(@reminder)
  end

  private
    def set_reminder
      @reminder = Reminder.find(params[:id])
    end

    def reminder_params
      params.fetch(:reminder, {}).permit(:user_id, :message, :sunday_enabled, :monday_enabled, :tuesday_enabled, :wednesday_enabled, :thursday_enabled, :friday_enabled, :saturday_enabled, :alert_time)
    end
end
