class SupportersController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @friends = current_user.friends
    @pending_friends = current_user.pending_friends
    @requested_friends = current_user.requested_friends
    
    thrivers = User.where.not(id: current_user.id)
    @supported_thrivers = []
    thrivers.each do |thriver|
      thriver.supporters.each do |thriver_id|
        if thriver_id == current_user.id
          @supported_thrivers << thriver
        end
      end
    end
  end
end
