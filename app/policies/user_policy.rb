class UserPolicy < ApplicationPolicy
  def index?
    false
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
    false
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