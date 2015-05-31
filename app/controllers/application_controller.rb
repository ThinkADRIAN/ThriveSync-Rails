class ApplicationController < ActionController::Base
  respond_to :html, :json
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

	before_filter do
	  resource = controller_name.singularize.to_sym
	  method = "#{resource}_params"
	  params[resource] &&= send(method) if respond_to?(method, true)
	end

	before_filter :configure_devise_params, if: :devise_controller?
		def configure_devise_params
			devise_parameter_sanitizer.for(:sign_up) do |u|
	  		u.permit(:first_name, :last_name, :email, :password, :password_confirmation, roles: [])
			end
			devise_parameter_sanitizer.for(:account_update) do |u|
	  		u.permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password, roles: [])
      end
      devise_parameter_sanitizer.for(:password_update) do |u|
        u.permit(:email, :password)
      end
		end

	alias_method :current_user, :current_user # Could be :current_member or :logged_in_user

  ActionController::Renderers.add :json do |json, options|
	  unless json.kind_of?(String)
	    json = json.as_json(options) if json.respond_to?(:as_json)
	    json = JSON.pretty_generate(json, options)
	  end

	  if options[:callback].present?
	    self.content_type ||= Mime::JS
	    "#{options[:callback]}(#{json})"
	  else
	    self.content_type ||= Mime::JSON
	    json
	  end
	end

	rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def ensure_signup_complete
    # Ensure we don't go into an infinite loop
    return if action_name == 'finish_signup'

    # Redirect to the 'finish_signup' page if the user
    # email hasn't been verified yet
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path(current_user)
    end
  end

  helper_method :pro_access_granted?
  protected
  def user_access_granted_index?
  	((current_user.is? :pro) && (current_user.clients.include?(params[:id].to_i))) || 
  	(current_user.id == params[:id].to_i) || (current_user.is? :superuser)
  end

  def user_access_granted_edit?
  	(current_user.is? :superuser)
  end

  def authorize_user_index
  	unless user_access_granted_index?
  		flash[:error] = "Unauthorized access"
  		redirect_to root_url
      false
    end
  end

  def authorize_user_edit
  	unless user_access_granted_edit?
  		flash[:error] = "Unauthorized access"
  		redirect_to root_url
      false
    end
  end
end