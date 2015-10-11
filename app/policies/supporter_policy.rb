class SupporterPolicy < ApplicationPolicy
  def index?
    authorize_current_user_and_super_user
  end

  def invite?
    authorize_current_user_and_super_user
  end
end