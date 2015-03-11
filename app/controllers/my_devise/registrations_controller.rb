class MyDevise::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_sign_up_params, only: [:create]
  before_filter :configure_account_update_params, only: [:update]

	def create
		# super
		build_resource(sign_up_params)

    resource.skip_confirmation!
		if resource.save!
			# whenever a new user is created, create a new Parse User and
			# populate the Parse User username and email with email that was just created
			if $PARSE_ENABLED
				parse_user = Parse::User.new(
		        {
		          :firstName => rails_user_params[:first_name],
		          :lastName => rails_user_params[:last_name],
		          :username => rails_user_params[:email],
		          :email => rails_user_params[:email],
		          :password => rails_user_params[:password],
		          :rails_user_id => resource.id.to_s
		        }
		    )
		    parse_user.save

        user = RailsUser.find_by(email: parse_user["email"])
        parse_user = Parse::Query.new("_User").eq("username", rails_user_params[:email]).get.first
        puid = parse_user["objectId"]
        user.update_attribute(:parse_user_id, puid)
        user.save
		  end

		  # Example Code to use REST API
		  if false # $PARSE_REST_ENABLED
		  	RestClient.post "https://api.parse.com/1/users", { 
					'username' => rails_user_params[:email],
					'email' => rails_user_params[:email],
					'password' => rails_user_params[:password],
					'firstName' => rails_user_params[:first_name],
				  'lastName' => rails_user_params[:last_name],
				  'rails_user_id' => resource.id.to_s,
					'x' => 1 }.to_json, 
					:X_Parse_Application_Id => ENV['PARSE_ID'],
					:X_Parse_REST_API_Key => ENV['PARSE_API_KEY'],
					:content_type => :json, :accept => :json
		  end
		end

		

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
		super
		if $PARSE_ENABLED
			user_to_update = current_rails_user
			updated_first_name = rails_user_params[:first_name]
			updated_last_name = rails_user_params[:last_name]
			updated_email_username = rails_user_params[:email]
			updated_password = rails_user_params[:password]
			current_parse_user = Parse::Query.new("_User").eq("username", user_to_update.email).get.first
			if current_parse_user != nil
			  current_parse_user["email"] = updated_email_username
	    	current_parse_user["username"] = updated_email_username
	    	current_parse_user["firstName"] = updated_first_name
	    	current_parse_user["lastName"] = updated_last_name
	    	current_parse_user["password"] = updated_password
		    current_parse_user.save
  		end
  	end
  end

	def destroy
		user_to_delete = current_rails_user
		super
		if resource.destroy && $PARSE_ENABLED
			current_parse_user = Parse::Query.new("_User").eq("email", user_to_delete.email).get.first
      current_parse_user.parse_delete
		end
	end

	private
	
	# Never trust parameters from the scary internet, only allow the white list through.
  def rails_user_params
    params.require(:rails_user).permit(:first_name, :last_name, :email, :password)
  end

	protected

  # You can put the params you want to permit in the empty array.
  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up) do |u|
  		u.permit(:first_name, :last_name, :email, :password, :password_confirmation, :parse_user_id, roles: [])
		end
  end

  # You can put the params you want to permit in the empty array.
  def configure_account_update_params
    devise_parameter_sanitizer.for(:account_update) do |u|
  		u.permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password, :parse_user_id, roles: [])
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