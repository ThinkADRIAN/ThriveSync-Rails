class MessagesController < ApplicationController
  resource_description do
    name 'T-Max Cards'
    short 'T-Max Cards'
    desc <<-EOS
      == Long description
        Send Cards between Supporters and their Thrivers
    EOS

    api_base_url ""
    formats ['html', 'json']
  end

  def_param_group :messages_data do
    param :thriver_id, :number, :desc => "Id of Recipient of T-Max Card [Number]", :required => true
    param :message, Hash, :desc => "Message", :required => false do
      param :body, :undef, :desc => "Message [String]", :required => true
      param :subject, :undef, :desc => "Category [String]", :required => true
    end
  end

  acts_as_token_authentication_handler_for User

  before_action :authenticate_user!
  before_action :set_thriver, only: [:new, :create]

  after_action :verify_authorized

  respond_to :html, :json

  def new
    authorize :message, :new?
    c = PreDefinedCard.all
    random_ids = c.ids.sort_by { rand }.slice(0, 3)
    @random_cards = PreDefinedCard.where(:id => random_ids)
  end

  api! "Send T-Max Card"
  param_group :messages_data

  def create
    # Limit Sending Messages between Supporters and their Thrivers
    if (current_user.is? :supporter) && (@thriver.supporters.include? current_user.id)
      skip_authorization
    else
      authorize :message, :create?
    end

    recipients = User.where(id: @thriver.id)
    conversation = current_user.send_message(recipients, params[:message][:body], params[:message][:subject]).conversation

    respond_to do |format|
      track_card_sent(@thriver)
      flash[:success] = 'Message has been sent!'
      format.html { redirect_to supporters_path }
      format.json { head :ok }
    end
  end

  api! "Draw Random T-Max Cards"

  def random_draw
    authorize :message, :random_draw?
    c = PreDefinedCard.all
    random_ids = c.ids.sort_by { rand }.slice(0, 3)
    @random_cards = PreDefinedCard.where(:id => random_ids)

    respond_to do |format|
      track_random_cards_drawn(@random_cards)
      format.json { render json: {cards: @random_cards}, status: 200 }
    end
  end

  private

  def set_thriver
    @thriver = User.find(params[:thriver_id])
  end

  def track_card_sent(recipient)
    # Track Card Sent for Segment.io Analytics
    Analytics.track(
      user_id: current_user.id,
      event: 'Card Sent',
      properties: {
        recipient_id: recipient.id
      }
    )
  end

  def track_random_cards_drawn(cards)
    # Track Random Cards Drawn for Segment.io Analytics
    cards.each do |card|
      Analytics.track(
        user_id: current_user.id,
        event: 'Random Cards Drawn',
        properties: {
          card_id: card.id
        }
      )
    end
  end
end