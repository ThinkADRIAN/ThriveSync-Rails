class ReviewsController < ApplicationController
  acts_as_token_authentication_handler_for User

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  #load_and_authorize_resource
  check_authorization

  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  respond_to :html, :js, :json, :xml

  Time.zone = 'EST'

  def index
    authorize! :manage, Review
    @user = User.find_by_id(params[:user_id])

    if @user == nil
      @reviews = Review.where(user_id: current_user.id)
    elsif @user != nil
      @reviews = Review.where(user_id: @user.id)
    end

    respond_to do |format|
      format.html
      format.json { render :json => @reviews, status: 200 }
    end
  end

  def show
    authorize! :manage, Review
    respond_with(@review)
  end

  def new
    authorize! :manage, Review
    @review = Review.new
    respond_with(@review)
  end

  def edit
    authorize! :manage, Review
  end

  def create
    authorize! :manage, Review
    @review = Review.new(review_params)
    @review.save
    respond_with(@review)
  end

  def update
    authorize! :manage, Review
    @review.update(review_params)
    respond_with(@review)
  end

  def destroy
    authorize! :manage, Review
    @review.destroy
    respond_with(@review)
  end


  private
    def set_review
      @review = Review.find(params[:id])
    end

    def review_params
      params.fetch(:review, {}).permit(:review_counter, :review_last_date, :review_trigger_date)
    end
end
