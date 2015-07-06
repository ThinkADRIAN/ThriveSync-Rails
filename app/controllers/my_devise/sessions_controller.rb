class Users::SessionsController < Devise::SessionsController
  before_filter :configure_sign_in_params, only: [:create, :destroy]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)

    # Track User Logged In for Segment.io Analytics
    Analytics.track(
      user_id: resource.id,
      event: 'Logged In',
      properties: {
      }
    )

    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  # DELETE /resource/sign_out
  def destroy
    token_was_removed = remove_current_users_token_if_json_request

    redirect_path = after_sign_out_path_for(resource_name)
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_navigational_format?

    respond_with resource do |format|
      format.html { redirect_to root_path }
      format.json {
        if token_was_removed

          # Track User Logged Out for Segment.io Analytics
          Analytics.track(
            user_id: resource.id,
            event: 'Logged Out',
            properties: {
            }
          )

          render :status=>200, :json=>{:message => "Logout successful." }
        else
          render :status=>401, :json=>{:message => "Logout failed. Invalid token or some internal server error while saving." }
        end
      }
    end
  end

  protected

  # You can put the params you want to permit in the empty array.
  def configure_sign_in_params
    devise_parameter_sanitizer.for(:sign_in) do |u|
      u.permit(:first_name, :last_name, :email, :password, :password_confirmation, roles: [])
    end
  end
end
