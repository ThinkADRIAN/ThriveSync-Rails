class FriendshipsController < ApplicationController
	before_filter :authenticate_user!

  def index
    @friends = current_user.friends
    @pending_friends = current_user.pending_friends
    @unconfirmed_friends = current_user.requested_friends
    @confirmed_friends = @friends - ( @pending_friends | @unconfirmed_friends)
    @users = User.where.not(id: current_user.id)
  end

  def new
    @users = User.where.not(id: current_user.id)

    @search = User.search do
      with(:email, params[:search])
    end

    @connections = @search.results
  end

  def create
    invitee = User.find_by_id(params[:user_id])
    if ((current_user.is? :pro) || (invitee.is? :pro))
	    if current_user.friend_request(invitee)
	      redirect_to new_connection_path, :notice => "Successfully sent connection request!"
	    else
	      redirect_to new_connection_path, :notice => "Sorry! You can't invite that user!"
	    end
	  else
	  	redirect_to new_connection_path, :notice => "Sorry! You can't invite that user!"
	  end
  end

  def update
    inviter = User.find_by_id(params[:id])
    if (current_user.accept_request(inviter))
    	
    	# Add user to Pros client list
    	if current_user.is? :pro
    		current_user.clients += [inviter.id.to_i]
    		current_user.save!
    	elsif inviter.is? :pro
    		inviter.clients += [current_user.id.to_i]
    		inviter.save!
    	end
    		
      redirect_to connections_path, :notice => "Successfully confirmed connection!"
    else
      redirect_to connections_path, :notice => "Sorry! Could not confirm connection!"
    end
  end

  def requests
    @pending_requests = current_user.requested_friends
  end

  def invites
    @pending_invites = current_user.pending_friends
  end

  def destroy
    user = User.find_by_id(params[:id])
    if current_user.remove_friend(user)

    	# Remote user to Pros client list
    	if current_user.is? :pro
    		current_user.clients -= [user.id.to_i]
    		current_user.save!
    	elsif user.is? :pro
    		user.clients -= [current_user.id.to_i]
    		user.save!
    	end
      redirect_to connections_path, :notice => "Successfully removed connection!"
    else
      redirect_to connections_path, :notice => "Sorry, couldn't remove connection!"
    end
  end
end
