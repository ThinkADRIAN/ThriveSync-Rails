class WelcomeController < ApplicationController
  def index
  	if rails_user_signed_in? && (current_rails_user.is? :superuser)
      # redirect_to :controller => 'moods', :action => 'index'
  		render "/superusers/index.html"
   	elsif rails_user_signed_in? && (current_rails_user.is? :admin)
   		render "/admins/index.html"
   	elsif rails_user_signed_in? && (current_rails_user.is? :pro)
   		render "/pros/index.html"
   	elsif rails_user_signed_in? && (current_rails_user.is? :client)
   		render "/clients/index.html"
    elsif rails_user_signed_in? && (current_rails_user.is? :user)
      render "/shared/index.html"
    end
  end
end