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
    if ((current_rails_user.is? :pro) || (invitee.is? :pro))
	    if current_rails_user.invite invitee
	      redirect_to new_connection_path, :notice => "Successfully sent connection request!"
	    else
	      redirect_to new_connection_path, :notice => "Sorry! You can't invite that user!"
	    end
	  else
	  	redirect_to new_connection_path, :notice => "Sorry! You can't invite that user!"
	  end
  end

  def update
    inviter = RailsUser.find_by_id(params[:id])
    if (current_rails_user.approve inviter)
    	
    	# Add user to Pros client list
    	if current_rails_user.is? :pro
    		current_rails_user.clients.push(params[:id].to_i)
    	elsif inviter.is? :pro
    		inviter.clients.push(params[:id].to_i)
    	end
    		
      redirect_to new_connection_path, :notice => "Successfully confirmed connection!"
    else
      redirect_to new_connection_path, :notice => "Sorry! Could not confirm connection!"
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
      redirect_to connections_path, :notice => "Successfully removed connection!"
    else
      redirect_to connections_path, :notice => "Sorry, couldn't remove connection!"
    end
  end
end
