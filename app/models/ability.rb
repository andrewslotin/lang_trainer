class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :manage, Dictionary, user_id: user._id
    can :manage, Book, dictionary: { user_id: user._id }
  end
end
