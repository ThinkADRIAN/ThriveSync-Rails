class MyDevise::RegistrationsController < Devise::RegistrationsController
	def create
		super #this call Devise::RegistrationsController#create
		# whenever a new user is created, create a new Parse User and
		# populate the Parse User username and email with email that was just created
		if resource.save
			parse_user = Parse::User.new(
	        {
	          :username => rails_user_params[:email],
	          :email => rails_user_params[:email],
	          :password => rails_user_params[:password]
	        }
	    )
	    parse_user.save
	  end
	end

	def update
		user_to_update = current_rails_user
		updated_email_username = rails_user_params[:email]
		current_parse_user = Parse::Query.new("_User").eq("username", user_to_update.email).get.first
		if current_parse_user != nil
			current_parse_user["email"] = updated_email_username
	    current_parse_user["username"] = updated_email_username
	    current_parse_user.save
  	end
    super
  end

	def destroy
		user_to_delete = current_rails_user
		super
		if resource.destroy
			current_parse_user = Parse::Query.new("_User").eq("email", user_to_delete.email).get.first
      current_parse_user.parse_delete
		end
	end

	private

	# Never trust parameters from the scary internet, only allow the white list through.
    def rails_user_params
      params.require(:rails_user).permit(:email, :password)
    end
end