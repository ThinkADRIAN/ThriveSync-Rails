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
    param :pre_defined_card, Hash, :desc => "Pre-Defined Card", :required => false do
      param :text, :undef, :desc => "Card Text [String]", :required => true
      param :category, :undef, :desc => "Card Category [String]", :required => true
    end
  end

  def_param_group :destroy_pre_defined_cards_data do
    param :id, :number, :desc => "Id of Pre-Defined Card to Delete [Number]", :required => true
  end

  acts_as_token_authentication_handler_for User

  before_action :authenticate_user!
  before_action :set_pre_defined_card, only: [:show, :edit, :update, :destroy]

  after_action :verify_authorized

  respond_to :html, :json

  # GET /pre_defined_cards
  # GET /pre_defined_cards.json
  api! "Show Pre-Defined Cards"

  def index
    authorize :pre_defined_card, :index?
    @pre_defined_cards = PreDefinedCard.all

    respond_to do |format|
      format.html
      format.json { render json: @pre_defined_cards, status: 200 }
    end
  end

  # GET /pre_defined_cards/1
  # GET /pre_defined_cards/1.json
  def show
    authorize :pre_defined_card, :show?

    respond_to do |format|
      format.html
      format.json { render json: @pre_defined_card, status: 200 }
    end
  end

  # GET /pre_defined_cards/new
  def new
    authorize :pre_defined_card, :new?
    @pre_defined_card = PreDefinedCard.new

    respond_to do |format|
      format.html
      format.json { render json: @pre_defined_card, status: 200 }
    end
  end

  # GET /pre_defined_cards/1/edit
  def edit
    authorize :pre_defined_card, :edit?

    respond_to do |format|
      format.html
      format.json { render json: @pre_defined_card, status: 200 }
    end
  end

  # POST /pre_defined_cards
  # POST /pre_defined_cards.json
  api! "Create Pre-Defined Card"
  param_group :pre_defined_cards_data

  def create
    authorize :pre_defined_card, :create?
    @pre_defined_card = PreDefinedCard.new(pre_defined_card_params)

    respond_to do |format|
      if @pre_defined_card.save
        track_pre_defined_card_created
        flash[:success] = 'Pre-Defined Card was successfully created.'
        format.html { redirect_to pre_defined_cards_path }
        format.json { render json: @pre_defined_card, status: :created }
      else
        flash[:error] = 'Pre-defined card was not created... Try again???'
        format.html { render :new }
        format.json { render json: @pre_defined_cards.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pre_defined_cards/1
  # PATCH/PUT /pre_defined_cards/1.json
  api! "Update Pre-Defined Card"
  param_group :pre_defined_cards_data

  def update
    authorize :pre_defined_card, :update?

    respond_to do |format|
      if @pre_defined_card.update(pre_defined_card_params)
        track_pre_defined_card_updated
        flash[:success] = 'Pre-Defined Card was successfully updated.'
        format.html { redirect_to pre_defined_cards_path }
        format.json { render json: @pre_defined_card, status: 200 }
      else
        flash[:error] = 'Pre-defined card was not updated... Try again???'
        format.html { render :edit }
        format.json { render json: @pre_defined_cards.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pre_defined_cards/1
  # DELETE /pre_defined_cards/1.json
  api! "Delete Pre-Defined Card"
  param_group :destroy_pre_defined_cards_data

  def destroy
    authorize :pre_defined_card, :destroy?

    respond_to do |format|
      if @pre_defined_card.destroy
        track_pre_defined_card_deleted
        flash[:success] = 'Pre-Defined Card was successfully deleted.'
        format.html { redirect_to pre_defined_cards_path }
        format.json { head :no_content }
      else
        flash[:error] = 'Pre-defined card was not deleted... Try again???'
        format.html { redirect pre_defined_cards_path }
        format.json { render json: @pre_defined_cards.errors, status: :unprocessable_entity }
      end
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
    # Track Pre-Defined Card Creation for Segment.io Analytics
    Analytics.track(
      user_id: current_user.id,
      event: 'Pre-Defined Card Created',
      properties: {
        pre_defined_card_id: @pre_defined_card.id,
        text: @pre_defined_card.text,
        category: @pre_defined_card.category
      }
    )
  end

  def track_pre_defined_card_updated
    # Track Pre-Defined Card Update for Segment.io Analytics
    Analytics.track(
      user_id: current_user.id,
      event: 'Pre-Defined Card Updated',
      properties: {
        pre_defined_card_id: @pre_defined_card.id,
        text: @pre_defined_card.text,
        category: @pre_defined_card.category
      }
    )
  end

  def track_pre_defined_card_deleted
    # Track Pre-Defined Card Deletion for Segment.io Analytics
    Analytics.track(
      user_id: current_user.id,
      event: 'Pre-Defined Card Deleted',
      properties: {
      }
    )
  end
end