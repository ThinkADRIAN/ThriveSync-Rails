class SupportersController < ApplicationController
  acts_as_token_authentication_handler_for User

  before_action :authenticate_user!

  respond_to :html, :json
  
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

    respond_to do |format|
      format.html
    end
  end

  def list_thrivers
    thrivers = User.where.not(id: current_user.id)
    @supported_thrivers = []
    thrivers.each do |thriver|
      thriver.supporters.each do |thriver_id|
        if thriver_id == current_user.id
          @supported_thrivers << thriver
        end
      end
    end

    respond_to do |format|
      format.json { render :json => @supported_thrivers, status: 200 }
    end
  end
end
