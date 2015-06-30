class MyDevise::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_sign_up_params, only: [:create]
  before_filter :configure_account_update_params, only: [:update]

	def create
    super
	end

  def edit
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
  		u.permit(:first_name, :last_name, :email, :timezone, :password, :password_confirmation, :current_password, roles: [], :reward_attributes => [:id, :rewards_enabled])
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