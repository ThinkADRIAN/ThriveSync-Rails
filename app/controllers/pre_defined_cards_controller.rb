class PreDefinedCardsController < ApplicationController
  resource_description do
    name 'Pre-Defined Cards'
    short 'Pre-Defined Cards'
    desc <<-EOS
      == Long description
        Pre-Defined Cards that can be sent as T-Max Cards
      EOS

    api_base_url ""
    formats ['html', 'json']
  end

  def_param_group :pre_defined_cards_data do
    param :text, :undef, :desc => "Card Text [String]", :required => true
    param :category, :undef, :desc => "Card Category [String]", :required => true
  end

  def_param_group :destroy_pre_defined_cards_data do
    param :id, :number, :desc => "Id of Pre-Defined Card to Delete [Number]", :required => true
  end

  acts_as_token_authentication_handler_for User

  before_action :authenticate_user!
  before_action :set_pre_defined_card, only: [:show, :edit, :update, :destroy]

  after_action :verify_authorized

  respond_to :html, :json

  api! "Show Pre-Defined Cards"
  def index
    authorize :pre_defined_card, :index?
    @pre_defined_cards = PreDefinedCard.all
    
    respond_to do |format|
      format.html
      format.json  { render :json => @pre_defined_cards, status: 200 }
    end
  end

  def show
    authorize :pre_defined_card, :show?

    respond_to do |format|
      format.html
      format.json  { render :json => @pre_defined_card, status: 200 }
    end
  end

  def new
    authorize :pre_defined_card, :new?
    @pre_defined_card = PreDefinedCard.new
    
    respond_to do |format|
      format.html
      format.json  { render :json => @pre_defined_card, status: 200 }
    end
  end

  api! "Edit Pre-Defined Card"
  param_group :pre_defined_cards_data
  def edit
    authorize :pre_defined_card, :edit?

    respond_to do |format|
      format.html
      format.json  { render :json => @pre_defined_card, status: 200 }
    end
  end

  api! "Create Pre-Defined Card"
  param_group :pre_defined_cards_data
  def create
    authorize :pre_defined_card, :create?
    @pre_defined_card = PreDefinedCard.new(pre_defined_card_params)
    @pre_defined_card.save

    track_pre_defined_card_created
    
    respond_to do |format|
      format.html
      format.json  { render :json => @pre_defined_card, status: 200 }
    end
  end

  api! "Update Pre-Defined Card"
  param_group :pre_defined_cards_data
  def update
    authorize :pre_defined_card, :update?
    @pre_defined_card.update(pre_defined_card_params)

    track_pre_defined_card_updated
    
    respond_to do |format|
      format.html
      format.json  { render :json => @pre_defined_card, status: 200 }
    end
  end

  api! "Delete Pre-Defined Card"
  param_group :destroy_pre_defined_cards_data
  def destroy
    authorize :pre_defined_card, :destroy?
    @pre_defined_card.destroy

    track_pre_defined_card_deleted
    
    respond_to do |format|
      format.html
      format.json  { head :no_content }
    end
  end

  private
  def set_pre_defined_card
    @pre_defined_card = PreDefinedCard.find(params[:id])
  end

  def pre_defined_card_params
    params.fetch(:pre_defined_card, {}).permit(:text, :category)
  end

  def track_pre_defined_card_created
    # Track Pre-Defined Card Created for Segment.io Analytics
    Analytics.track(
      user_id: current_user.id,
      event: 'Pre-Defined Card Created',
      properties: {
        text: @pre_defined_card.text,
        category: @pre_defined_card.category
      }
    )
  end

  def track_pre_defined_card_updated
    # Track Pre-Defined Card Updated for Segment.io Analytics
    Analytics.track(
        user_id: current_user.id,
        event: 'Pre-Defined Card Updated',
        properties: {
            text: @pre_defined_card.text,
            category: @pre_defined_card.category
        }
    )
  end

  def track_pre_defined_card_deleted
    # Track Pre-Defined Card Deleted for Segment.io Analytics
    Analytics.track(
        user_id: current_user.id,
        event: 'Pre-Defined Card Deleted',
        properties: {
        }
    )
  end
end
