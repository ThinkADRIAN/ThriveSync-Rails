class ApplicationController < ActionController::Base
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
	  		u.permit(:name, :email, :password, :password_confirmation)
			end
			devise_parameter_sanitizer.for(:account_update) do |u|
	  		u.permit(:name, :email, :password, :password_confirmation, :current_password)
			end
		end

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
end