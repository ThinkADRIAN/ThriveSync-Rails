module MessagesHelper
  def recipients_options
    @friends = current_user.friends
    @pending_friends = current_user.pending_friends
    @requested_friends = current_user.requested_friends
    @users = User.where.not(id: current_user.id)
  	
  	if !@friends.empty?
  		for user in @friends
  			if current_user.friend_with? user
          s = ''
	      	s << "<option value='#{user.id}'>#{user.first_name} #{user.last_name}</option>"
	      end
	    end
	    s.html_safe
	  end
  end
end

# Send to Clients
=begin
  	@users = User.where(:email == !nil).sort_by { |r| r.last_name.downcase }
  	
  	if !@users.empty?
	    s = ''
	    @users.each do |user|
	    	if current_user.clients.include? user.id
	      	s << "<option value='#{user.id}'>#{user.name}</option>"
	      end
	    end
	    s.html_safe
	  end
=end