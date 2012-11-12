class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, Dictionary, user_id: user.id
  end
end
