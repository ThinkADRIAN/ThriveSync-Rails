class ReviewPolicy < ApplicationPolicy
  def index?
    authorize_current_user_and_super_user
  end

  def show?
    index?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    authorize_current_user_and_super_user
  end

  def edit?
    update?
  end

  def destroy?
    false
  end
end