class SubscriptionPlanPolicy < ApplicationPolicy
  def index?
    if user.is? :superuser
      true
    else
      false
    end
  end

  def show?
    if user.is? :superuser
      true
    else
      false
    end
  end

  def create?
    if user.is? :superuser
      true
    else
      false
    end
  end

  def new?
    create?
  end

  def update?
    if user.is? :superuser
      true
    else
      false
    end
  end

  def edit?
    update?
  end

  def destroy?
    if user.is? :superuser
      true
    else
      false
    end
  end

  class Scope < Scope
    def resolve
      if user.is? :superuser
        scope.all
      else
        scope
      end
    end
  end
end
