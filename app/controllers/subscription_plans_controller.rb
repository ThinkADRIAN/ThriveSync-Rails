class SubscriptionPlansController < ApplicationController
  before_action :set_subscription_plan, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @subscription_plans = SubscriptionPlan.all
    respond_with(@subscription_plans)
  end

  def show
    respond_with(@subscription_plan)
  end

  def new
    @subscription_plan = SubscriptionPlan.new
    respond_with(@subscription_plan)
  end

  def edit
  end

  def create
    @subscription_plan = SubscriptionPlan.new(subscription_plan_params)
    @subscription_plan.save
    respond_with(@subscription_plan)
  end

  def update
    @subscription_plan.update(subscription_plan_params)
    respond_with(@subscription_plan)
  end

  def destroy
    @subscription_plan.destroy
    respond_with(@subscription_plan)
  end

  private
    def set_subscription_plan
      @subscription_plan = SubscriptionPlan.find(params[:id])
    end

    def subscription_plan_params
      params.require(:subscription_plan).permit(:amount, :interval, :stripe_id, :name, :interval_count, :trial_period_days)
    end
end
