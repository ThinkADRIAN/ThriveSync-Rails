class WelcomeController < ApplicationController
  def index
  	if user_signed_in?
  		# redirect_to :controller => 'moods', :action => 'index'
  		render "/shared/index.html"
  	end
  end
end