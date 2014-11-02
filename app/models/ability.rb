class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities

    # handle guest user (not logged in)
    user ||= RailsUser.new() 

    can :manage, :all if user.is? :superuser

    can :assign_roles, RailsUser if user.is? :superuser

    can :manage, Mood do |mood|
      if 
        user.is? :superuser
      elsif 
        mood.user_id == @rails_user_id
      end
    end

    can :read, Mood do |mood|
      user.is? :pro && (user.clients.include? mood.user_id)
    end

    can :manage, Sleep do |sleep|
      sleep.user_id == user.id
    end

    can [:read, :create], Sleep do |sleep|
      sleep.user_id != user.id
    end

    can :manage, SelfCare do |self_care|
      self_care.user_id == user.id
    end

    can [:read, :create], SelfCare do |self_care|
      self_care.user_id != user.id
    end

    can :manage, Journal do |journal|
      journal.user_id == user.id
    end

    can [:read, :create], Journal do |journal|
      journal.user_id != user.id
    end
  end
end