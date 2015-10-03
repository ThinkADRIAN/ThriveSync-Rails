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
          if @friends.include? thriver
            @supported_thrivers << thriver
          end
        end
      end
    end

    @pending_thrivers = []
    @pending_friends.each do |pending_friend|
      if !pending_friend.is? :pro
        @pending_thrivers << pending_friend
      end
    end

    @requested_thrivers = []
    @requested_friends.each do |requested_friend|
      if !requested_friend.is? :pro
        @requested_thrivers << requested_friend
      end
    end

    @supporters = []
    current_user.supporters.each do |supporter_id|
      @supporters << User.where(id: supporter_id)
    end

    respond_to do |format|
      format.html
      format.json { render :json => @supporters, status: 200 }
    end
  end

  def invite
    invitee = User.find_by_email(params[:email])

    # Handle if invitee account already exists and is not already an existing supporter
    if invitee != nil && !(invitee.is? :pro) && !(current_user.supporters.include? invitee.id.to_i)
      current_user.supporters += [invitee.id.to_i]
      current_user.save!
      current_user.friend_request(invitee)
      invitee.roles += ["supporter"]
      invitee.save!

      respond_to do |format|
        format.json { render :json  => { status: "Supporter Invitation Successful Sent" }}
      end
    # Handle if invitee account already exists and is already an existing supporter
    elsif invitee != nil && !(invitee.is? :pro) && (current_user.supporters.include? invitee.id.to_i)
      respond_to do |format|
        format.json { render :json => { :error => "This email is associated to an existing supporter." }}
      end
    # Handle if invitee account is a pro
    elsif invitee != nil && (invitee.is? :pro)
      respond_to do |format|
        format.json { render :json => { :error => "Mental Health Providers cannot be invited as a peer supporter." }}
      end
    # Default invitation for new users
    else
      User.invite!({:email => params[:email]}, current_user)

      respond_to do |format|
        format.json { head :ok }
      end
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
