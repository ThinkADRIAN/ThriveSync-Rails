class RailsUsers::SessionsController < Devise::SessionsController
  before_filter :configure_sign_in_params, only: [:create, :destroy]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    if $PARSE_ENABLED
      self.resource = warden.authenticate!(auth_options)

      email = resource_params[:email]
      password = resource_params[:password]
      begin

        user = Parse::User.authenticate(resource_params[:email], resource_params[:password])

        if user
          super
        elsif
          redirect_to new_rails_user_session_path, :notice => 'Invalid Parse Username or password.'
        end
      rescue Parse::ParseProtocolError
        signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
        redirect_to new_rails_user_session_path, :notice => 'Invalid Parse Username or password.'
      end
    else
      super
    end
  end

  def reset_parse_password
  end

  # DELETE /resource/sign_out
  def destroy
    if $PARSE_ENABLED
      session[:user_id] = nil
      super
    else
      super
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
