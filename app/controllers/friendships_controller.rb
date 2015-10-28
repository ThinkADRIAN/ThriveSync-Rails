class FriendshipsController < ApplicationController
  resource_description do
    name 'Connections'
    short 'Connections'
    desc <<-EOS
      == Long description
        Create relationships between users.
      EOS

    api_base_url ""
    formats ['html', 'json']
  end

  def_param_group :create_connections_data do
    param :user_id, :number, :desc => "Id of Invitee to Send Request for Connection [Number]", :required => true
  end

  def_param_group :update_connections_data do
    param :id, :number, :desc => "Id of Inviter to Confirm Connection [Number]", :required => true
  end

  def_param_group :destroy_connections_data do
    param :id, :number, :desc => "Id of User to Disconnect Connection [Number]", :required => true
  end

  acts_as_token_authentication_handler_for User

	before_action :authenticate_user!

  before_action :set_friends, only: [:index, :thrivers, :supporters, :patients, :providers]
  before_action :set_pending_friends, only: [:index, :thrivers, :supporters, :patients, :providers]
  before_action :set_requested_friends, only: [:index, :thrivers, :supporters, :patients, :providers]

  before_action :set_thrivers, only: [:index, :thrivers]
  before_action :set_pending_thrivers, only: [:index, :thrivers]
  before_action :set_requested_thrivers, only: [:index, :thrivers]

  before_action :set_supporters, only: [:index, :supporters]
  before_action :set_pending_supporters, only: [:index, :supporters]
  before_action :set_requested_supporters, only: [:index, :supporters]

  before_action :set_patients, only: [:index, :patients]
  before_action :set_pending_patients, only: [:index, :patients]
  before_action :set_requested_patients, only: [:index, :patients]

  before_action :set_providers, only: [:index, :providers]
  before_action :set_pending_providers, only: [:index, :providers]
  before_action :set_requested_providers, only: [:index, :providers]

  before_action :set_excluded_fields, only: [:index, :thrivers, :supporters, :patients, :providers]

  after_action :verify_authorized

  respond_to :html, :json

  api! "Show Connections"
  def index
    authorize :friendship, :index?
    respond_to do |format|
      format.html
      format.json  { render :json => {
        :_thrivers => @supported_thrivers, 
        :pending_thrivers => @pending_supported_thrivers,
        :requested_thrivers => @requested_supported_thrivers,
        :_supporters => @supporters,
        :pending_supporters => @pending_supporters,
        :requested_supporters => @requested_supporters,
        :_patients => @patients, 
        :pending_patients => @pending_patients,
        :requested_patients => @requested_patients,
        :_providers => @providers, 
        :pending_providers => @pending_providers,
        :requested_providers => @requested_providers },
        :except =>  @excluded_fields,
        status: 200
      }
    end
  end

  api! "Show Thriver Connections"
  def thrivers
    authorize :friendship, :index?
    respond_to do |format|
      format.html
      format.json  { render :json => {
        :_thrivers => @supported_thrivers, 
        :pending_thrivers => @pending_supported_thrivers,
        :requested_thrivers => @requested_supported_thrivers },
        :except =>  @excluded_fields,
        status: 200
      }
    end
  end

  api! "Show Supporter Connections"
  def supporters
    authorize :friendship, :index?
    respond_to do |format|
      format.html
      format.json  { render :json => {
        :_supporters => @supporters, 
        :pending_supporters => @pending_supporters,
        :requested_supporters => @requested_supporters },
        :except =>  @excluded_fields,
        status: 200
      }
    end
  end

  api! "Show Patient Connections"
  def patients
    authorize :friendship, :index?
    respond_to do |format|
      format.html
      format.json  { render :json => {
        :_patients => @patients, 
        :pending_patients => @pending_patients,
        :requested_patients => @requested_patients },
        :except =>  @excluded_fields,
        status: 200
      }
    end
  end

  api! "Show Provider Connections"
  def providers
    authorize :friendship, :index?
    respond_to do |format|
      format.html
      format.json  { render :json => {
        :_providers => @providers, 
        :pending_providers => @pending_providers,
        :requested_providers => @requested_providers },
        :except =>  @excluded_fields,
        status: 200
      }
    end
  end

  def new
    authorize :friendship, :new?
    @connections = User.where(email: params[:search]).to_a
  end

  api! "Create Connection"
  param_group :create_connections_data
  def create
    authorize :friendship, :create?
    invitee = User.find_by_id(params[:user_id])
    if ((current_user.is? :pro) || (invitee.is? :pro))
	    if current_user.friend_request(invitee)
        track_connnection_created(invitee)
	      redirect_to connections_path, :notice => "Successfully sent connection request!"
	    else
	      redirect_to new_connection_path, :notice => "Sorry! You can't invite that user!"
	    end
	  else
	  	redirect_to new_connection_path, :notice => "Sorry! You can't invite that user!"
	  end
  end

  api! "Update Connection (aka Accept Connection Request)"
  param_group :update_connections_data
  def update
    authorize :friendship, :update?
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

      track_connection_updated(inviter)

      respond_to do |format|
        format.html { redirect_to :back, :notice => "Successfully confirmed connection!" }
        format.json { render :json  => { status: "Successfully confirmed connection!" }}
      end
    else
      respond_to do |format|
        format.html { redirect_to :back, :notice => "Sorry, couldn't confirm connection!" }
        format.json { render :json  => { status: "Sorry, couldn't confirm connection!" }}
      end
    end
  end

  api! "Destroy Connection (aka Remove Connection)"
  param_group :destroy_connections_data
  def destroy
    authorize :friendship, :destroy?
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

      track_connection_deleted(user)

      respond_to do |format|
        format.html { redirect_to :back, :notice => "Successfully removed connection!" }
        format.json { render :json  => { status: "Successfully removed connection!" }}
      end
    else
      respond_to do |format|
        format.html { redirect_to :back, :notice => "Sorry, couldn't remove connection!" }
        format.json { render :json  => { status: "Sorry, couldn't remove connection!" }}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_friends
      @friends = current_user.friends
    end

    def set_pending_friends
      @pending_friends = current_user.pending_friends
    end

    def set_requested_friends
      @requested_friends = current_user.requested_friends
    end

    def set_thrivers
      @supported_thrivers = []
      @friends.each do |thriver|
        thriver.supporters.each do |thriver_id|
          if thriver_id == current_user.id
            @supported_thrivers << thriver
          end
        end
      end
    end

    def set_pending_thrivers
      @pending_supported_thrivers = []
      @pending_friends.each do |thriver|
        thriver.supporters.each do |thriver_id|
          if thriver_id == current_user.id
            @pending_supported_thrivers << thriver
          end
        end
      end
    end

    def set_requested_thrivers
      @requested_supported_thrivers = []
      @requested_friends.each do |thriver|
        thriver.supporters.each do |thriver_id|
          if thriver_id == current_user.id
            @requested_supported_thrivers << thriver
          end
        end
      end
    end

    def set_supporters
      @supporters = []
      current_user.supporters.each do |supporter_id|
        candidate = User.find_by_id(supporter_id)
        if @friends.include? candidate
          @supporters << User.find_by_id(supporter_id)
        end
      end
    end

    def set_pending_supporters
      @pending_supporters = []
      @pending_friends.each do |pending_friend|
        if !pending_friend.is? :pro
          @pending_supporters << pending_friend
        end
      end
    end

    def set_requested_supporters
      @requested_supporters = []
      @requested_friends.each do |requested_friend|
        if !requested_friend.is? :pro
          @requested_supporters << requested_friend
        end
      end
    end

    def set_patients
      @patients = []
      current_user.clients.each do |patient_id|
        @patients << User.find_by_id(patient_id)
      end
    end

    def set_pending_patients
      @pending_patients = []
      @pending_friends.each do |pending_friend|
        if pending_friend.is? :user
          @pending_patients << pending_friend
        end
      end
    end

    def set_requested_patients
      @requested_patients = []
      @requested_friends.each do |requested_friend|
        if requested_friend.is? :user
          @requested_patients << requested_friend
        end
      end
    end

    def set_providers
      @providers = []
      @friends.each do |friend|
        if friend.is? :pro
          @providers << friend
        end
      end
    end

    def set_pending_providers
      @pending_providers = []
      @pending_friends.each do |pending_friend|
        if pending_friend.is? :pro
          @pending_providers << pending_friend
        end
      end
    end

    def set_requested_providers
      @requested_providers = []
      @requested_friends.each do |requested_friend|
        if requested_friend.is? :pro
          @requested_providers << requested_friend
        end
      end
    end

    def set_excluded_fields
      @excluded_fields = [
        :created_at,
        :updated_at,
        :roles_mask,
        :clients,
        :authentication_token,
        :last_active_at,
        :timezone,
        :invitation_token,
        :invitation_created_at,
        :invitation_sent_at,
        :invitation_accepted_at,
        :invitation_limit,
        :invited_by_id,
        :invited_by_type,
        :supporters
      ]
    end

    def track_connnection_created(invitee)
      # Track Connection Creation for Segment.io Analytics
      Analytics.track(
        user_id: current_user.id,
        event: 'Connection Created',
        properties: {
          invitee_id: invitee.id
        }
      )
    end

    def track_connection_updated(inviter)
      # Track Connection Update for Segment.io Analytics
      Analytics.track(
        user_id: current_user.id,
        event: 'Connection Updated',
        properties: {
          inviter_id: inviter.id
        }
      )
    end

    def track_connection_deleted(user)
      # Track Connection Deletion for Segment.io Analytics
      Analytics.track(
        user_id: current_user.id,
        event: 'Connection Deleted',
        properties: {
          user_id: user.id
        }
      )
    end
end