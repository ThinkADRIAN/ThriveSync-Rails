class MyDevise::SessionsController < Devise::SessionsController
  include ParseHelper

  acts_as_token_authentication_handler_for User

  before_filter :configure_sign_in_params, only: [:create, :destroy]
  skip_before_filter :verify_signed_out_user
  skip_before_filter  :verify_authenticity_token, only:[:destroy]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    user_email = params[:user][:email]
    user_password = params[:user][:password]

    # Check if Parse User exists
    if parse_user_exists?(user_email)
      # Migration has been run in the past
      if get_last_migration_date(user_email) != nil
        rails_authenticate
      # Migration has not been run yet
      else
        login_to_parse(user_email, user_password)

        # Check If Parse Login Successful
        if @parse_user != nil
          if rails_user_exists?(user_email)
            rails_authenticate
          else
            user_first_name = @parse_user["firstName"]
            user_last_name = @parse_user["lastName"]

            create_new_rails_user(user_first_name, user_last_name, user_email, user_password)

            etl_for_parse(@new_rails_user.id, user_email, user_password)

            # Sign In with New Rails User
            # Code originally from rails_authenticate method edited for this use case.
            sign_in(resource_name, @new_rails_user)

            yield @new_rails_user if block_given?
            respond_with @new_rails_user, location: after_sign_in_path_for(@new_rails_user)
          end
        else
          render :status=>401, :json=>{:message => "Parse::ParseProtocolError: 101: invalid login parameters" }
        end
      end
    # Parse User does not exists
    else
      rails_authenticate
    end
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

  # Code for Devise Create Action aka Rails Authenticate
  def rails_authenticate
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)

    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  # Create New Rails User
  def create_new_rails_user(new_user_first_name, new_user_last_name, new_user_email, new_user_password)
    @new_rails_user = User.new(:first_name => new_user_first_name, :last_name => new_user_last_name, :email => new_user_email, :password => new_user_password, :password_confirmation => new_user_password)
    @new_rails_user.skip_confirmation!
    @new_rails_user.save!
  end
end
