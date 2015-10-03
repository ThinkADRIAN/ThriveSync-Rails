class MessagesController < ApplicationController
  acts_as_token_authentication_handler_for User

  before_action :authenticate_user!
  before_action :set_thriver, only: [:new, :create]

  respond_to :html, :json

  def new
  	c = PreDefinedCard.all
  	random_ids = c.ids.sort_by { rand }.slice(0, 3)
  	@random_cards = PreDefinedCard.where(:id => random_ids)
  end

  def create
    recipients = User.where(id: @thriver.id)
    conversation = current_user.send_message(recipients, params[:message][:body], params[:message][:subject]).conversation
    flash[:success] = "Message has been sent!"

    respond_to do |format|
      format.html { redirect_to supporters_path }
      format.json { head :ok }
    end 
  end

  def random_draw
    c = PreDefinedCard.all
    random_ids = c.ids.sort_by { rand }.slice(0, 3)
    @random_cards = PreDefinedCard.where(:id => random_ids)

    respond_to do |format|
      format.json { render :json => @random_cards, status: 200}
    end 
  end

  private

  def set_thriver
    @thriver = User.find(params[:thriver_id])
  end
end