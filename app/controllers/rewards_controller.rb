class RewardsController < ApplicationController
  resource_description do
    name 'Rewards'
    short 'Rewards'
    desc <<-EOS
      == Long description
        Store data for Mobile App Reward Cues
      EOS

    api_base_url ""
    formats ['html', 'json']
  end

  def_param_group :create_rewards_data do
    param :user_id, :number, :desc => "User Id [Number]", :required => true
    param :rewards_enabled, :bool, :desc => "Rewards Enabled [Boolean]", :required => true
  end

  def_param_group :update_rewards_data do
    param :user_id, :number, :desc => "User Id [Number]", :required => false
    param :rewards_enabled, :bool, :desc => "Rewards Enabled [Boolean]", :required => false
  end

  def_param_group :destroy_rewards_data do
    param :id, :number, :desc => "Id of Reward Record to Delete [Number]", :required => true
  end

  acts_as_token_authentication_handler_for User

  before_action :authenticate_user!
  before_action :set_reward, only: [:show, :edit, :update, :destroy]

  after_action :verify_authorized

  respond_to :html, :json

  api! "Show Rewards Record"
  def index
    authorize :reminder, :index?
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      @reward = Reward.where(user_id: current_user.id)
    elsif @user != nil
      @reward = Reward.where(user_id: @user.id)
    end

    respond_to do |format|
      format.html
      format.json { render :json => @reward, status: 200 }
    end
  end

  def show
    authorize :reminder, :show?
    
    respond_to do |format|
      format.html
      format.json { render :json => @reward, status: 200 }
    end
  end

  def new
    authorize :reminder, :new?
    @reward = Reward.new
    
    respond_to do |format|
      format.html
      format.json { render :json => @reward, status: 200 }
    end
  end

  api! "Edit Reward Record"
  def edit
    authorize :reminder, :edit?

    respond_to do |format|
      format.html
      format.json { render :json => @reward, status: 200 }
    end
  end

  api! "Create Reward Record"
  param_group :create_rewards_data
  def create
    authorize :reminder, :create?
    @reward = Reward.new(reward_params)
    @reward.save

    track_reward_created
    
    respond_to do |format|
      format.html
      format.json { render :json => @reward, status: 200 }
    end
  end

  api! "Update Reward Record"
  param_group :update_rewards_data
  def update
    authorize :reminder, :update?
    @reward.update(reward_params)

    track_reward_updated
    
    respond_to do |format|
      format.html
      format.json { render :json => @reward, status: 200 }
    end
  end

  api! "Delete Reward Record"
  param_group :destroy_rewards_data
  def destroy
    authorize :reminder, :destroy?
    @reward.destroy

    reward_deleted
    
    respond_to do |format|
      format.html
      format.json  { head :no_content }
    end
  end

  private
  def set_reward
    @reward = Reward.find(params[:id])
  end

  def reward_params
    params.fetch(:reward, {}).permit(:user_id, :rewards_enabled)
  end
  
  def track_reward_created
    # Track Reward Created for Segment.io Analytics
    Analytics.track(
        user_id: current_user.id,
        event: 'Reward Created',
        properties: {
            reward_id: @reward.id,
            reward_user_id: @reward.rewards_enabled,
            reward_user_id: @reward.user_id
        }
    )
  end

  def track_reward_updated
    # Track Reward Updated for Segment.io Analytics
    Analytics.track(
        user_id: current_user.id,
        event: 'Reward Updated',
        properties: {
            reward_id: @reward.id,
            reward_user_id: @reward.rewards_enabled,
            reward_user_id: @reward.user_id
        }
    )
  end

  def track_reward_deleted
    # Track Reward Deleted for Segment.io Analytics
    Analytics.track(
        user_id: current_user.id,
        event: 'Reward Deleted',
        properties: {
        }
    )
  end
  
end
