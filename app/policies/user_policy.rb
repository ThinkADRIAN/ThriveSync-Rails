class UserPolicy < ApplicationPolicy
  def index?
    if user.is? :superuser
      true
    else
      false
    end
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
    false
  end

  def finish_signup?
    true
  end

  def migrate_from_thrivetracker?
    if user
      true
    else
      false
    end
  end

  def request_password_reset_from_thrivetracker?
    if user
      true
    else
      false
    end
  end
end