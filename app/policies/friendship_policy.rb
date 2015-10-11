class FriendshipPolicy < ApplicationPolicy
  def index?
    authorize_current_user_and_super_user
  end

  def create?
    authorize_current_user_and_super_user
  end

  def new?
    create?
  end

  def update?
    authorize_current_user_and_super_user
  end

  def destroy?
    authorize_current_user_and_super_user
  end 

  protected
    def authorize_current_user_and_super_user
      if user || (user.is? :superuser)
        true
      else
        false
      end
    end 
end
