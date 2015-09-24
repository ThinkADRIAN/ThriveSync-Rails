class FriendshipsController < ApplicationController
	before_filter :authenticate_user!

  def index
    @friends = current_user.friends
    @pending_friends = current_user.pending_friends
    @requested_friends = current_user.requested_friends
    @users = User.where.not(id: current_user.id)

    @providers = []
    current_user.supporters.each do |provider_id|
      @providers << User.find_by_id(provider_id)
    end

    @pending_providers = []
    @pending_friends.each do |pending_friend|
      if pending_friend.is? :pro
        @pending_providers << pending_friend
      end
    end

    @requested_providers = []
    @requested_friends.each do |requested_friend|
      if requested_friend.is? :pro
        @pending_providers << requested_friend
      end
    end
  end

  def supporters
    @friends = current_user.friends
    @pending_friends = current_user.pending_friends
    @requested_friends = current_user.requested_friends
    @users = User.where.not(id: current_user.id)

    @supporters = []
    current_user.supporters.each do |supporter_id|
      @supporters << User.find_by_id(supporter_id)
    end

    @pending_supporters = []
    @pending_friends.each do |pending_friend|
      if !pending_friend.is? :pro
        @pending_supporters << pending_friend
      end
    end

    @requested_supporters = []
    @requested_friends.each do |requested_friend|
      if !requested_friend.is? :pro
        @requested_supporters << requested_friend
      end
    end
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
	      redirect_to connections_path, :notice => "Successfully sent connection request!"
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

    	# Remove user from Pros clients list
    	if current_user.is? :pro
    		current_user.clients -= [user.id.to_i]
    		current_user.save!
    	elsif user.is? :pro
    		user.clients -= [current_user.id.to_i]
    		user.save!
    	end

      # Remove user from Thrivers supporters list
      if current_user.is? :supporter
        user.supporters -= [current_user.id.to_i]
        user.save!
      elsif user.is? :supporter
        current_user.supporters -= [user.id.to_i]
        current_user.save!
      end

      respond_to do |format|
        format.html { redirect_to :back, :notice => "Successfully removed connection!" }
      end
    else
      respond_to do |format|
        format.html { redirect_to :back, :notice => "Sorry, couldn't remove connection!" }
      end
    end
  end
end
