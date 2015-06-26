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
    user ||= User.new()

    can :manage, Scorecard do |scorecard|
      scorecard.user_id == @user_id
    end

    can :manage, Reward do |reward|
      reward.user_id == @user_id
    end

    can :manage, User, id: user.id
    can :manage, Mood, :user => { id: user.id }
    can :manage, Sleep, :user => { id: user.id }
    can :manage, SelfCare, :user => { id: user.id }
    can :manage, Journal, :user => { id: user.id }
    can :manage, Journal, :user => { id: user.id }
    can :manage, Reminder, :user => { id: user.id }

    if user.is? :pro
      can :read, Mood do |mood|
        user.clients.include? mood.user_id
      end

      can :read, Sleep do |sleep|
        user.clients.include? sleep.user_id
      end

      can :read, SelfCare do |self_care|
        user.clients.include? self_care.user_id
      end

      can :read, Journal if user.clients.include? :user_id
    end

    if user.is? :superuser
      can :manage, :all
      can :assign_roles, User
    end
  end
end