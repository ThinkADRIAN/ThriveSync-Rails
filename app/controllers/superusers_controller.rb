class SuperusersController < ApplicationController
  before_action :authenticate_user!

  # http://localhost:3000/superusers/1/export_moods.csv?email=thriver-5@thrivesync.com
  def export_moods
    user_email = params[:email]
    @user = User.where(email: user_email).first
    @moods = Mood.where(user_id: @user.id)

    respond_to do |format|
      if current_user.is? :superuser
        format.csv { send_data @moods.to_csv, filename: "#{@user.email} - Mood Data.csv" }
      end
    end
  end

  # http://localhost:3000/superusers/1/export_sleeps.csv?email=thriver-5@thrivesync.com
  def export_sleeps
    user_email = params[:email]
    @user = User.where(email: user_email).first
    @sleeps = Sleep.where(user_id: @user.id)

    respond_to do |format|
      if current_user.is? :superuser
        format.csv { send_data @sleeps.to_csv, filename: "#{@user.email} - Sleep Data.csv" }
      end
    end
  end

  # http://localhost:3000/superusers/1/export_self_cares.csv?email=thriver-5@thrivesync.com
  def export_self_cares
    user_email = params[:email]
    @user = User.where(email: user_email).first
    @self_cares = SelfCare.where(user_id: @user.id)

    respond_to do |format|
      if current_user.is? :superuser
        format.csv { send_data @self_cares.to_csv, filename: "#{@user.email} - Self Care Data.csv" }
      end
    end
  end

  # http://localhost:3000/superusers/1/export_journals.csv?email=thriver-5@thrivesync.com
  def export_journals
    user_email = params[:email]
    @user = User.where(email: user_email).first
    @journals = Journal.where(user_id: @user.id)

    respond_to do |format|
      if current_user.is? :superuser
        format.csv { send_data @journals.to_csv, filename: "#{@user.email} - Journal Data.csv" }
      end
    end
  end

end
