class UsersController < ApplicationController
	before_action :authenticate_rails_user!
	
	def new
	end
end
