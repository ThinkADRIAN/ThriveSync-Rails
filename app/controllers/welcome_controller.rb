class WelcomeController < ApplicationController
  def index
  	if user_signed_in?
  		redirect_to :controller => 'moods', :action => 'index'
  	end
  end
end