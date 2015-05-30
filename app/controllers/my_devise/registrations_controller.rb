class MyDevise::RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, only: [ :new, :create, :edit, :update, :cancel ]
  prepend_before_filter :authenticate_scope!, only: [:destroy]
  acts_as_token_authentication_handler_for User

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
    super
	end

	def update
		super
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
  		u.permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password, roles: [])
		end
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    super(resource)
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    super(resource)
  end
end