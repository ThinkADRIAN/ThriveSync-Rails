class SubscriptionPlansController < ApplicationController
  acts_as_token_authentication_handler_for User
  before_action :authenticate_user!
  before_action :set_subscription_plan, only: [:show, :edit, :update, :destroy]

  after_action :verify_authorized, except: [:index]

  respond_to :html, :json

  def index
    @subscription_plans = SubscriptionPlan.all
    authorize @subscription_plans

    respond_to do |format|
      format.html
      format.json { render json: @subscription_plans, status: 200 }
    end
  end

  def show
    authorize @subscription_plan
  end

  def new
    @subscription_plan = SubscriptionPlan.new
    authorize @subscription_plan
    return @subscription_plan
  end

  def edit
  end

  def create
    @subscription_plan = SubscriptionPlan.new(subscription_plan_params)
    authorize @subscription_plan

    respond_to do |format|
      if @subscription_plan.save
        track_subscription_plan_created
        flash.now[:success] = 'Subscription Plan  was successfully created.'
        format.html { redirect_to subscription_plans_path }
        format.json { render json: @subscription_plan, status: :created }
      else
        flash.now[:error] = 'Subscription Plan  was not created... Try again???'
        format.html { render :new }
        format.json { render json: @subscription_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @subscription_plan

    respond_to do |format|
      if @subscription_plan.update(subscription_plan_params)
        track_subscription_plan_updated
        flash.now[:success] = 'Subscription Plan was successfully updated.'
        format.html { redirect_to @subscription_plan, notice: 'Subscription Plan was successfully updated.' }
        format.json { render json: @subscription_plan, status: 200 }
      else
        flash.now[:error] = 'Subscription Plan was not updated... Try again???'
        format.html { render :edit }
        format.json { render json: @subscription_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @subscription_plan

    respond_to do |format|
      if @subscription_plan.destroy
        track_subscription_plan_deleted
        flash[:success] = 'Subscription Plan was successfully deleted.'
        format.html { redirect_to subscription_plans_path }
        format.json { head :no_content }
      else
        flash[:error] = 'Subscription Plan was not deleted... Try again???'
        format.html { redirect subscription_plans_path }
        format.json { render json: @subscription_plans.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_subscription_plan
      @subscription_plan = SubscriptionPlan.find(params[:id])
    end

    def subscription_plan_params
      params.fetch(:subscription_plan, {}).permit(:amount, :interval, :stripe_id, :name, :interval_count, :trial_period_days)
    end

  def track_subscription_plan_created
    # Track Subscription Plan Creation for Segment.io Analytics
    Analytics.track(
      user_id: current_user.id,
      event: 'Subscription Plan Created',
      properties: {
        subscription_plan_id: @subscription_plan.id,
        subscription_plan_amount: @subscription_plan.amount,
        subscription_plan_interval: @subscription_plan.interval,
        subscription_plan_stripe_id: @subscription_plan.stripe_id,
        subscription_plan_name: @subscription_plan.name,
        subscription_plan_interval_count: @subscription_plan.interval_count,
        subscription_plan_trial_period_days: @subscription_plan.trial_period_days
      }
    )
  end

  def track_subscription_plan_updated
    # Track Subscription Plan Update for Segment.io Analytics
    Analytics.track(
      user_id: current_user.id,
      event: 'Subscription Plan Updated',
      properties: {
        subscription_plan_id: @subscription_plan.id,
        subscription_plan_amount: @subscription_plan.amount,
        subscription_plan_interval: @subscription_plan.interval,
        subscription_plan_stripe_id: @subscription_plan.stripe_id,
        subscription_plan_name: @subscription_plan.name,
        subscription_plan_interval_count: @subscription_plan.interval_count,
        subscription_plan_trial_period_days: @subscription_plan.trial_period_days
      }
    )
  end

  def track_subscription_plan_deleted
    # Track Device Deletion for Segment.io Analytics
    Analytics.track(
      user_id: current_user.id,
      event: 'Subscription Plan Deleted',
      properties: {
      }
    )
  end
end
