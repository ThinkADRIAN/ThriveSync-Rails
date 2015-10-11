class PreDefinedCardPolicy < ApplicationPolicy
  def index?
    authorize_super_user
  end

  def show?
    authorize_super_user
  end

  def create?
    authorize_super_user
  end

  def new?
    create?
  end

  def update?
    authorize_super_user
  end

  def edit?
    update?
  end

  def destroy?
    authorize_super_user
  end
end
