class SupportersController < ApplicationController
  resource_description do
    name 'Supporters'
    short 'Supporters'
    desc <<-EOS
      == Long description
        Supporters are connected to Thrivers to provide peer support
      EOS

    api_base_url ""
    formats ['html', 'json']
  end

  def_param_group :supporters_data do
    param :email, :undef, :desc => "Email Address of Invited Supporter [String]", :required => true
  end

  acts_as_token_authentication_handler_for User

  before_action :authenticate_user!

  after_action :verify_authorized

  respond_to :json

  # GET /supporters
  # GET /supporters.json
  api! "Show Supporters"
  def index
    authorize :supporter, :index?
    @friends = current_user.friends
    @pending_friends = current_user.pending_friends
    @requested_friends = current_user.requested_friends
    
    thrivers = User.where.not(id: current_user.id)
    @supported_thrivers = []
    thrivers.each do |thriver|
      thriver.supporters.each do |thriver_id|
        if thriver_id == current_user.id
          if @friends.include? thriver
            @supported_thrivers << thriver
          end
        end
      end
    end

    @pending_thrivers = []
    @pending_friends.each do |pending_friend|
      if !pending_friend.is? :pro
        @pending_thrivers << pending_friend
      end
    end

    @requested_thrivers = []
    @requested_friends.each do |requested_friend|
      if !requested_friend.is? :pro
        @requested_thrivers << requested_friend
      end
    end

    @supporters = []
    current_user.supporters.each do |supporter_id|
      @supporters << User.where(id: supporter_id)
    end

    respond_to do |format|
      format.json  { render json: @supporters, status: 200 }
    end
  end

  # POST /supporters/invite
  # POST /supporters/invite.json
  api! "Invite Supporter"
  param_group :supporters_data
  def invite
    authorize :supporter, :invite?
    invitee = User.find_by_email(params[:email])

    # Handle if invitee account already exists and is not already an existing supporter
    if invitee != nil && !(invitee.is? :pro) && !(current_user.supporters.include? invitee.id.to_i)
      current_user.supporters += [invitee.id.to_i]
      current_user.save!
      current_user.friend_request(invitee)
      invitee.roles += ["supporter"]
      invitee.save!

      track_supporter_invited(invitee)

      respond_to do |format|
        format.json { render :json  => { status: "Supporter Invitation Successful Sent" }}
      end
    # Handle if invitee account already exists and is already an existing supporter
    elsif invitee != nil && !(invitee.is? :pro) && (current_user.supporters.include? invitee.id.to_i)
      respond_to do |format|
        format.json { render :json => { :error => "This email is associated to an existing supporter." }}
      end
    # Handle if invitee account is a pro
    elsif invitee != nil && (invitee.is? :pro)
      respond_to do |format|
        format.json { render :json => { :error => "Mental Health Providers cannot be invited as a peer supporter." }}
      end
    # Default invitation for new users
    else
      User.invite!({:email => params[:email]}, current_user)

      respond_to do |format|
        format.json { head :ok }
      end
    end
  end

  private

  def track_supporter_invited(invitee)
    # Track Supporter Invitation for Segment.io Analytics
    Analytics.track(
        user_id: current_user.id,
        event: 'Invited Supporter',
        properties: {
            invitee_id: invitee.id
        }
    )
  end
end
