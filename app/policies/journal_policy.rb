class JournalPolicy < ApplicationPolicy
  def index?
    false
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
      elsif user.is? :pro
        client_id = scope.first.user_id
        if user.clients.include? client_id
          scope
        else
          scope = nil
        end
      else
        scope
      end
    end
  end
end
