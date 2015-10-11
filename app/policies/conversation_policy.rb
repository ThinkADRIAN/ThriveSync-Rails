class ConversationPolicy < ApplicationPolicy
  def show?
    authorize_current_user_and_super_user
  end

  def index?
    authorize_current_user_and_super_user
  end

  def destroy?
    authorize_current_user_and_super_user
  end

  def restore?
    authorize_current_user_and_super_user
  end

  def empty_trash?
    authorize_current_user_and_super_user
  end

  def mark_as_read?
    authorize_current_user_and_super_user
  end  
end
