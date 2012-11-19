class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, Dictionary, user_id: user.id
    can :manage, Book, :dictionary => { user_id: user.id }
  end
end
