class SuperusersController < ApplicationController
	before_action :authenticate_rails_user!
end
