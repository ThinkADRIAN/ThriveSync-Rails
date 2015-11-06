module MessagesHelper
  def recipients_options
    @friends = current_user.friends
  	
  	if !@friends.empty?
  		for user in @friends
  			if @thriver.supporters.include? current_user.id
          s = ''
	      	s << "<option value='#{@thriver.id}'>#{@thriver.first_name} #{@thriver.last_name}</option>"
	      end
	    end
	    s.html_safe
	  end
  end
end