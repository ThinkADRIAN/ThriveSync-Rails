class WelcomeController < ApplicationController
  def index
    if current_user.nil?
      render :layout => "welcome"
    else
      if user_signed_in? && (current_user.is? :superuser)
        # redirect_to :controller => 'moods', :action => 'index'
        render "/superusers/index.html", :layout => "application"
      elsif user_signed_in? && (current_user.is? :admin)
        render "/admins/index.html",:layout => "application"
      elsif user_signed_in? && (current_user.is? :pro)
        redirect_to pros_path, :layout => "application"
      elsif user_signed_in? && (current_user.is? :supporter)
        redirect_to supporters_path, :layout => "application"
      elsif user_signed_in? && (current_user.is? :client)
        render "/clients/index.html", :layout => "application"
      elsif user_signed_in? && (current_user.is? :user)
        render "/shared/index.html", :layout => "application"
      end
    end
  end
end