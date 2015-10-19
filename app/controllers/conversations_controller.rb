class ConversationsController < ApplicationController
  acts_as_token_authentication_handler_for User

  before_action :authenticate_user!
  before_action :get_mailbox
  before_action :get_conversation, except: [:index, :empty_trash]
  before_action :get_box, only: [:index]

  after_action :verify_authorized

  respond_to :html, :json

  def show
    authorize :conversation, :show?
  end

  def index
    authorize :conversation, :index?
    if @box.eql? "inbox"
      @conversations = @mailbox.inbox
    elsif @box.eql? "sent"
      @conversations = @mailbox.sentbox
    else
      @conversations = @mailbox.trash
    end

    @conversations = @conversations.paginate(page: params[:page], per_page: 9)

    @cards = []
    @conversations.each do |conversation|
      @cards << {
        :category => conversation.last_message.subject, 
        :message => conversation.last_message.body,
        :sender_first_name => conversation.last_message.sender.first_name,
        :sender_last_name => conversation.last_message.sender.last_name,
        :sent_time => conversation.last_message.created_at
      }
    end

    respond_to do |format|
      format.html
      format.json { render :json => { :cards => @cards }, status: 200 }
    end 
  end

  def destroy
    authorize :conversation, :destroy?
    @conversation.move_to_trash(current_user)
    flash[:success] = 'The conversation was moved to trash.'
    redirect_to conversations_path
  end

  def restore
    authorize :conversation, :restore?
    @conversation.untrash(current_user)
    flash[:success] = 'The conversation was restored.'
    redirect_to conversations_path
  end

  def empty_trash
    authorize :conversation, :empty_trash?
    @mailbox.trash.each do |conversation|
      conversation.receipts_for(current_user).update_all(deleted: true)
    end
    flash[:success] = 'Your trash was cleaned!'
    redirect_to conversations_path
  end

  def mark_as_read
    authorize :conversation, :mark_as_read?
    @conversation.mark_as_read(current_user)
    flash[:success] = 'The conversation was marked as read.'
    redirect_to conversations_path
  end

  private

  def get_mailbox
    @mailbox ||= current_user.mailbox
  end

  def get_conversation
    @conversation ||= @mailbox.conversations.find(params[:id])
  end

  def get_box
    if params[:box].blank? or !["inbox","sent","trash"].include?(params[:box])
      params[:box] = 'inbox'
    end
    @box = params[:box]
  end
end