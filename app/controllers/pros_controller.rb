class ProsController < ApplicationController
	before_filter :authenticate_user!
	
	def index
    @friends = current_user.friends
    @pending_friends = current_user.pending_friends
    @requested_friends = current_user.requested_friends
    @users = User.where.not(id: current_user.id)
  end
end
