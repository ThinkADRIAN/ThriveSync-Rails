class RailsUsers::SessionsController < Devise::SessionsController
  before_filter :configure_sign_in_params, only: [:create, :destroy]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    super
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  protected

  # You can put the params you want to permit in the empty array.
  def configure_sign_in_params
    devise_parameter_sanitizer.for(:sign_in) do |u|
      u.permit(:first_name, :last_name, :email, :password, :password_confirmation, roles: [])
    end
  end
end
