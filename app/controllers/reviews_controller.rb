class ReviewsController < ApplicationController
  resource_description do
    name 'Reviews'
    short 'Reviews'
    desc <<-EOS
      == Long description
        Store data for Mobile App Review Cues
    EOS

    api_base_url ""
    formats ['html', 'json']
  end

  def_param_group :reviews_data do
    param :review_counter, :number, :desc => "Review Counter [Number]", :required => false
    param :review_last_date, :undef, :desc => "Review Last Date [DateTime]", :required => false
    param :review_trigger_date, :undef, :desc => "Review Trigger Date [DateTime]", :required => false
  end

  def_param_group :destroy_reviews_data do
    param :id, :number, :desc => "Id of Review Entry to Delete [Number]", :required => true
  end

  acts_as_token_authentication_handler_for User

  before_action :authenticate_user!
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  after_action :verify_authorized

  respond_to :html, :json

  # GET /reviews
  # GET /reviews.json
  api! "Show Review Records"

  def index
    authorize :review, :index?
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

  # GET /reviews/1
  # GET /reviews/1.json
  def show
    authorize :review, :show?

    respond_to do |format|
      format.html
      format.json { render :json => @review, status: 200 }
    end
  end

  # GET /reviews/new
  def new
    authorize :review, :new?
    @review = Review.new

    respond_to do |format|
      format.html
      format.json { render :json => @review, status: 200 }
    end
  end

  # GET /reviews/1/edit
  def edit
    authorize :review, :edit?

    respond_to do |format|
      format.html
      format.json { render :json => @review, status: 200 }
    end
  end

  # POST /reviews
  # POST /reviews.json
  api! "Create Review Record"
  param_group :reviews_data

  def create
    authorize :review, :create?
    @review = Review.new(review_params)

    respond_to do |format|
      if @review.save
        track_review_created
        flash[:success] = 'Review was successfully created.'
        format.html { redirect_to reviews_path }
        format.json { render json: @review, status: :created }
      else
        flash[:error] = 'Review was not created... Try again???'
        format.html { render :new }
        format.json { render json: @reviews.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  api! "Update Review Record"
  param_group :reviews_data

  def update
    authorize :review, :update?

    respond_to do |format|
      if @review.update(review_params)
        track_review_updated
        flash[:success] = 'Review was successfully updated.'
        format.html { redirect_to reviews_path }
        format.json { render json: @review, status: 200 }
      else
        flash[:error] = 'Review was not updated... Try again???'
        format.html { render :edit }
        format.json { render json: @reviews.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  api! "Delete Review Record"
  param_group :destroy_reviews_data

  def destroy
    authorize :review, :destroy?

    respond_to do |format|
      if @review.destroy
        track_review_deleted
        flash[:success] = 'Review was successfully deleted.'
        format.html { redirect_to reviews_path }
        format.json { head :no_content }
      else
        flash[:error] = 'Review was not deleted... Try again???'
        format.html { redirect reviews_path }
        format.json { render json: @reviews.errors, status: :unprocessable_entity }
      end
    end
  end


  private
  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.fetch(:review, {}).permit(:review_counter, :review_last_date, :review_trigger_date)
  end

  def track_review_created
    # Track Review Creation for Segment.io Analytics
    Analytics.track(
      user_id: current_user.id,
      event: 'Review Created',
      properties: {
        review_id: @review.id,
        review_counter: @review.review_counter,
        review_last_date: @review.review_last_date,
        review_trigger_date: @review.review_trigger_date,
        review_user_id: @review.user_id
      }
    )
  end

  def track_review_updated
    # Track Review Update for Segment.io Analytics
    Analytics.track(
      user_id: current_user.id,
      event: 'Review Updated',
      properties: {
        review_id: @review.id,
        review_counter: @review.review_counter,
        review_last_date: @review.review_last_date,
        review_trigger_date: @review.review_trigger_date,
        review_user_id: @review.user_id
      }
    )
  end

  def track_review_deleted
    # Track Review Deletion for Segment.io Analytics
    Analytics.track(
      user_id: current_user.id,
      event: 'Review Deleted',
      properties: {
      }
    )
  end
end