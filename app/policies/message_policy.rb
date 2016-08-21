class MessagePolicy < ApplicationPolicy
  def new?
    authorize_current_user_and_super_user
  end

  def create?
    false
  end

  def random_draw?
    authorize_current_user_and_super_user
  end
end
