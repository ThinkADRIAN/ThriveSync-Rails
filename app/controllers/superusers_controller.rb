class SuperusersController < ApplicationController
  before_action :authenticate_user!

  def export_moods_csv
    user_email = params[:email]
    @user = User.where(email: user_email).first
    @moods = Mood.where(user_id: @user.id)

    respond_to do |format|
      format.html
      format.csv { send_data @moods.to_csv }
    end
  end

  def export_sleeps_csv
    user_email = params[:email]
    @user = User.where(email: user_email).first
    @sleeps = Sleep.where(user_id: @user.id)

    respond_to do |format|
      format.html
      format.csv { send_data @sleeps.to_csv }
    end
  end

  def export_self_cares_csv
    user_email = params[:email]
    @user = User.where(email: user_email).first
    @self_cares = SelfCare.where(user_id: @user.id)

    respond_to do |format|
      format.html
      format.csv { send_data @self_cares.to_csv }
    end
  end

  def export_journals_csv
    user_email = params[:email]
    @user = User.where(email: user_email).first
    @journals = Journal.where(user_id: @user.id)

    respond_to do |format|
      format.html
      format.csv { send_data @journals.to_csv }
    end
  end

end
