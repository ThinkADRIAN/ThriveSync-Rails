class ProsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @friends = current_user.friends
    @pending_friends = current_user.pending_friends
    @requested_friends = current_user.requested_friends

    @clients = []
    current_user.clients.each do |client_id|
      @clients += User.where(id: client_id)
    end
  end
end
