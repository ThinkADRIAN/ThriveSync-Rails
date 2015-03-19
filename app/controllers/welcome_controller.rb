class WelcomeController < ApplicationController
  def index
    if current_user.nil?
      render :layout => "welcome"
    else
      if rails_user_signed_in? && (current_rails_user.is? :superuser)
        # redirect_to :controller => 'moods', :action => 'index'
        render "/superusers/index.html", :layout => "application"
      elsif rails_user_signed_in? && (current_rails_user.is? :admin)
        render "/admins/index.html",:layout => "application"
      elsif rails_user_signed_in? && (current_rails_user.is? :pro)
        render "/pros/index.html", :layout => "application"
      elsif rails_user_signed_in? && (current_rails_user.is? :client)
        render "/clients/index.html", :layout => "application"
      elsif rails_user_signed_in? && (current_rails_user.is? :user)
        render "/shared/index.html", :layout => "application"
      end
    end
  end
end