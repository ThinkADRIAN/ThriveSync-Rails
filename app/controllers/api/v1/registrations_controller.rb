class Api::V1::RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, only: [ :new, :create, :edit, :update, :cancel ]
  prepend_before_filter :authenticate_scope!, only: [:destroy]
  acts_as_token_authentication_handler_for User, fallback_to_devise: false

  # Disable token authentication for all actions
  # See https://github.com/gonzalo-bulnes/simple_token_authentication/blob/master/lib/simple_token_authentication/acts_as_token_authentication_handler.rb#L12-L15
  skip_before_filter :authenticate_user_from_token!
  skip_before_filter :authenticate_user!

  # Enable token authentication only for the :update, :destroy actions
  before_filter :authenticate_user_from_token!, :only => [:update, :destroy]
  before_filter :authenticate_user!, :only => [:update, :destroy]

  before_filter :configure_sign_up_params, only: [:create]
  before_filter :configure_account_update_params, only: [:update]

	def create
    build_resource(sign_up_params)

    resource.save

    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
	end

	def update
		self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)

    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, bypass: true
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

	def destroy
		super
	end

	private
	
	# Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end

	protected

  # You can put the params you want to permit in the empty array.
  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up) do |u|
  		u.permit(:first_name, :last_name, :email, :password, :password_confirmation, roles: [])
		end
  end

  # You can put the params you want to permit in the empty array.
  def configure_account_update_params
    devise_parameter_sanitizer.for(:account_update) do |u|
  		u.permit(:first_name, :last_name, :email, :timezone, :password, :password_confirmation, :current_password, roles: [], :reward_attributes => [:id, :rewards_enabled])
		end
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    self.identify_user_for_analytics
    self.track_user_sign_up
    super(resource)
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    super(resource)
  end

  # The path used after update.
  def after_update_path_for(resource)
    self.identify_user_for_analytics
    self.track_user_update
    signed_in_root_path(resource)
  end

  def identify_user_for_analytics
    # Identify User for Segment.io Analytics
    Analytics.identify(
      user_id: resource.id,
      traits: {
        first_name: resource.first_name,
        last_name: resource.last_name,
        email: resource.email,
        created_at: resource.created_at
      }
    )
  end

  def track_user_sign_up
    # Track User Sign Up for Segment.io Analytics
    Analytics.track(
      user_id: resource.id,
      event: 'Signed Up',
      properties: {
      }
    )
  end

  def track_user_update
    # Track User Detail Update for Segment.io Analytics
    Analytics.track(
      user_id: resource.id,
      event: 'User Detail Updated',
      properties: {
      }
    )
  end
end