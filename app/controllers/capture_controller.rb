class CaptureController < ApplicationController
  acts_as_token_authentication_handler_for User

  before_action :authenticate_user!
  before_action :set_capture_date, only: [:update_capture]

  after_action :verify_authorized

  respond_to :js

  def update_capture
    authorize :capture, :update_capture?
    @user = User.find_by_id(params[:user_id])

    if $current_capture_screen == nil
      $current_capture_screen = DEFAULT_CAPTURE_SCREEN
    end

    respond_to do |format|
      format.js
    end
  end

  private

  def set_capture_date
    if (params.has_key?(:capture_date))
      $capture_date = Date.parse(params[:capture_date])
    else
      $capture_date = Date.parse(DEFAULT_CAPTURE_DATE)
    end
  end
end