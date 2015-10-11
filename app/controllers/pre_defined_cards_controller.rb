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

  def_param_group :pre_defined_cards_destroy_data do
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
    
    respond_to do |format|
      format.html
      format.json  { render :json => @pre_defined_card, status: 200 }
    end
  end

  api! "Delete Pre-Defined Card"
  param_group :pre_defined_cards_destroy_data
  def destroy
    authorize :pre_defined_card, :destroy?
    @pre_defined_card.destroy
    
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
end
