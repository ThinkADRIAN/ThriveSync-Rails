class MessagesController < ApplicationController
  before_action :authenticate_user!

  def new
  	c = PreDefinedCard.all
	random_ids = c.ids.sort_by { rand }.slice(0, 3)
	@random_cards = PreDefinedCard.where(:id => random_ids)
  end

  def create
    recipients = User.where(id: params['recipients'])
    conversation = current_user.send_message(recipients, params[:message][:body], params[:message][:subject]).conversation
    flash[:success] = "Message has been sent!"
    redirect_to conversations_path#conversation_path(conversation)
  end
end