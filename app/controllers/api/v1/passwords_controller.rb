class Api::V1::PasswordsController < Devise::PasswordsController
  resource_description do
    short 'Passwords'
    desc <<-EOS
      == Long description
        Used for managing password credentials.
      EOS
    api_base_url "/api"
    # api_version "v1"
    formats ['html', 'json']
  end

  acts_as_token_authentication_handler_for User, fallback_to_devise: false

  prepend_before_filter :require_no_authentication
  # Render the #edit only if coming from a reset password email link
  append_before_filter :assert_reset_token_passed, only: :edit

  # GET /resource/password/new
  def new
    super
  end

  # POST /resource/password
  api! "Reset Password via Email"
  param :email, String, :desc => "Email Address for Thriver Requesting Password Reset"
  def create
    super
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    super
  end

  # PUT /resource/password
  def update
    # super

    self.resource = resource_class.reset_password_by_token(params[resource_name])

    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message) if is_navigational_format?

      respond_with resource, :location => after_resetting_password_path_for(resource)
    else
      respond_with resource
    end
  end

  protected

    def after_resetting_password_path_for(resource)
      # super(resource)
      new_session_path(resource)
    end

    # The path used after sending reset password instructions
    def after_sending_reset_password_instructions_path_for(resource_name)
      super(resource_name)
    end
end
