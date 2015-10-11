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

  def_param_group :reviews_destroy_data do
    param :id, :number, :desc => "Id of Review Entry to Delete [Number]", :required => true
  end

  acts_as_token_authentication_handler_for User

  before_action :authenticate_user!
  before_action :set_review, only: [:show, :edit, :update, :destroy]
 
  after_action :verify_authorized

  respond_to :html, :json

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

  def show
    authorize :review, :show?
    
    respond_to do |format|
      format.html
      format.json { render :json => @review, status: 200 }
    end
  end

  def new
    authorize :review, :new?
    @review = Review.new
    
    respond_to do |format|
      format.html
      format.json { render :json => @review, status: 200 }
    end
  end

  api! "Edit Review Record"
  def edit
    authorize :review, :edit?

    respond_to do |format|
      format.html
      format.json { render :json => @review, status: 200 }
    end
  end

  api! "Create Review Record"
  param_group :reviews_data
  def create
    authorize :review, :create?
    @review = Review.new(review_params)
    @review.save
    
    respond_to do |format|
      format.html
      format.json { render :json => @review, status: 200 }
    end
  end

  api! "Update Review Record"
  def update
    authorize :review, :update?
    @review.update(review_params)
    
    respond_to do |format|
      format.html
      format.json { render :json => @review, status: 200 }
    end
  end

  api! "Delete Review Record"
  param_group :reviews_destroy_data
  def destroy
    authorize :review, :destroy?
    @review.destroy
    
    respond_to do |format|
      format.html
      format.json  { head :no_content }
    end
  end


  private
    def set_review
      @review = Review.find(params[:id])
    end

    def review_params
      params.fetch(:review, {}).permit(:review_counter, :review_last_date, :review_trigger_date)
    end
end
