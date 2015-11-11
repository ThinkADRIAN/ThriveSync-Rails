class Users::SessionsController < Devise::SessionsController
  acts_as_token_authentication_handler_for User

  before_filter :configure_sign_in_params, only: [:create, :destroy]
  skip_before_filter :verify_signed_out_user
  skip_before_filter :verify_authenticity_token, only: [:destroy]

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
    # super
    token_was_removed = remove_current_users_token_if_json_request

    redirect_path = after_sign_out_path_for(resource_name)
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_navigational_format?

    respond_with resource do |format|
      format.html { redirect_to root_path }
      format.json {
        if token_was_removed
          render :status => 200, :json => {:message => "Logout successful."}
        else
          render :status => 401, :json => {:message => "Logout failed. Invalid token or some internal server error while saving."}
        end
      }
    end
  end

  protected

  def verify_signed_out_user
    if all_signed_out?
      set_flash_message :notice, :already_signed_out if is_flashing_format?

      respond_to_on_destroy
    end
  end

  def all_signed_out?
    users = Devise.mappings.keys.map { |s| warden.user(scope: s, run_callbacks: false) }

    users.all?(&:blank?)
  end

  def respond_to_on_destroy
    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to after_sign_out_path_for(resource_name) }
    end
  end

  # You can put the params you want to permit in the empty array.
  def configure_sign_in_params
    devise_parameter_sanitizer.for(:sign_in) do |u|
      u.permit(:first_name, :last_name, :email, :password, :password_confirmation, roles: [])
    end
  end

  def remove_current_users_token_if_json_request
    #remove the users authentication token if user is logged in
    if current_user and request.format.json?
      current_user.authentication_token = nil
      return current_user.save
    else
      return false
    end
  end
end
