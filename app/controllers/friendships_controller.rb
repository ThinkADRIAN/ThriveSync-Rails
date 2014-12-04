class FriendshipsController < ApplicationController
	before_filter :authenticate_rails_user!

  def index
    @friends = current_rails_user.friends
  end

  def new
    @rails_users = RailsUser.where.not(id: current_rails_user.id)
  end

  def create
    invitee = RailsUser.find_by_id(params[:rails_user_id])
    if current_rails_user.invite invitee
      redirect_to new_friend_path, :notice => "Successfully invited friend!"
    else
      redirect_to new_friend_path, :notice => "Sorry! You can't invite that user!"
    end
  end

  def update
    inviter = RailsUser.find_by_id(params[:id])
    if current_rails_user.approve inviter
      redirect_to new_friend_path, :notice => "Successfully confirmed friend!"
    else
      redirect_to new_friend_path, :notice => "Sorry! Could not confirm friend!"
    end
  end

  def requests
    @pending_requests = current_rails_user.pending_invited_by
  end

  def invites
    @pending_invites = current_rails_user.pending_invited
  end

  def destroy
    user = RailsUser.find_by_id(params[:id])
    if current_rails_user.remove_friendship user
      redirect_to friends_path, :notice => "Successfully removed friend!"
    else
      redirect_to friends_path, :notice => "Sorry, couldn't remove friend!"
    end
  end
end
