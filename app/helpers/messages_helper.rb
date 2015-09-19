module MessagesHelper
  def recipients_options
  	@friends = current_user.friends
    @pending_friends = current_user.pending_invited_by
    @unconfirmed_friends = current_user.pending_invited
    @confirmed_friends = @friends - ( @pending_friends | @unconfirmed_friends)
    @users = User.where.not(id: current_user.id)
  	
  	if !@confirmed_friends.empty?
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