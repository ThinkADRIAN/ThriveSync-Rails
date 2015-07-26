class CaptureController < ApplicationController
  acts_as_token_authentication_handler_for User

  before_action :authenticate_user!
  before_action :set_capture_date, only: [:update_capture]

  respond_to :html, :js, :json
  
  def update_capture
    @user = User.find_by_id(params[:user_id])

    respond_to do |format|
      format.js
    end
  end

  private

    def set_capture_date
      if(params.has_key?(:capture_date))
        @capture_date = Date.parse(params[:capture_date])
      else
        @capture_date = Date.parse(DEFAULT_CAPTURE_DATE)
      end
    end
end