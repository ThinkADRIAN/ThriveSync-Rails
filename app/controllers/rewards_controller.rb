class RewardsController < ApplicationController
  acts_as_token_authentication_handler_for User

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  #load_and_authorize_resource
  check_authorization

  before_action :set_reward, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  respond_to :html, :js, :json, :xml

  Time.zone = 'EST'

  def index
    authorize! :manage, Reward
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
    authorize! :manage, Reward
    respond_with(@reward)
  end

  def new
    authorize! :manage, Reward
    @reward = Reward.new
    respond_with(@reward)
  end

  def edit
    authorize! :manage, Reward
  end

  def create
    authorize! :manage, Reward
    @reward = Reward.new(reward_params)
    @reward.save
    respond_with(@reward)
  end

  def update
    authorize! :manage, Reward
    @reward.update(reward_params)
    respond_with(@reward)
  end

  def destroy
    authorize! :manage, Reward
    @reward.destroy
    respond_with(@reward)
  end

  private
    def set_reward
      @reward = Reward.find(params[:id])
    end

    def reward_params
      params.fetch(:reward, {}).permit(:user_id, :rewards_enabled)
    end
end
