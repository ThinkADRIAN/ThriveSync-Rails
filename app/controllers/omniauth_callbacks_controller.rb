class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @rails_user = RailsUser.find_for_oauth(env["omniauth.auth"], current_rails_user)

        if @rails_user.persisted?

          # Create Parse User As necessary
          if $PARSE_ENABLED
            current_parse_user = Parse::Query.new("_User").eq("username", @rails_user[:email]).get.first
            if current_parse_user.blank?
              parse_user = Parse::User.new(
                  {
                    :firstName => @rails_user[:first_name],
                    :lastName => @rails_user[:last_name],
                    :username => @rails_user[:email],
                    :email => @rails_user[:email],
                    :password => @rails_user[:password].to_s,
                    :rails_user_id => @rails_user.id.to_s
                  }
              )
              parse_user.save
            end
		      end

          sign_in_and_redirect @rails_user, event: :authentication
          set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
        else
          session["devise.#{provider}_data"] = env["omniauth.auth"]
          redirect_to new_user_registration_url
        end
      end
    }
  end

  [:google_oauth2, :twitter, :facebook].each do |provider|
    provides_callback_for provider
  end

  def after_sign_in_path_for(resource)
    if resource.email_verified?
      super resource
    else
      finish_signup_path(resource)
    end
  end
end