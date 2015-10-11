class PreDefinedCardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pre_defined_card, only: [:show, :edit, :update, :destroy]

  after_action :verify_authorized

  respond_to :html

  def index
    authorize :pre_defined_card, :index?
    @pre_defined_cards = PreDefinedCard.all
    respond_with(@pre_defined_cards)
  end

  def show
    authorize :pre_defined_card, :show?
    respond_with(@pre_defined_card)
  end

  def new
    authorize :pre_defined_card, :new?
    @pre_defined_card = PreDefinedCard.new
    respond_with(@pre_defined_card)
  end

  def edit
    authorize :pre_defined_card, :edit?
  end

  def create
    authorize :pre_defined_card, :create?
    @pre_defined_card = PreDefinedCard.new(pre_defined_card_params)
    @pre_defined_card.save
    respond_with(@pre_defined_card)
  end

  def update
    authorize :pre_defined_card, :update?
    @pre_defined_card.update(pre_defined_card_params)
    respond_with(@pre_defined_card)
  end

  def destroy
    authorize :pre_defined_card, :destroy?
    @pre_defined_card.destroy
    respond_with(@pre_defined_card)
  end

  private
    def set_pre_defined_card
      @pre_defined_card = PreDefinedCard.find(params[:id])
    end

    def pre_defined_card_params
      params.require(:pre_defined_card).permit(:text, :category)
    end
end
