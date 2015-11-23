class DevicePolicy < ApplicationPolicy
  def index?
    if user.is? :superuser
      true
    end
  end

  def show?
    if user.id == record.user_id
      true
    else
      false
    end
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
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
