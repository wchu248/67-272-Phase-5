class Ability
  include CanCan::Ability

  def initialize(user)
    # set user to new User if not logged in
    user ||= User.new # i.e., a guest user

    if user.role? :admin
      # admins can do everything
      can :manage, :all
    elsif user.role? :manager
      nil
    elsif user.role? :shipper
      nil
    elsif user.role? :customer
      can :show, User do |u|
        u.id == user.id
      end
      can :update, User do |u|
        u.id == user.id
      end
      can :read, Item
    else
      # guest action
      can :read, Item
      can :create, User
    end
  end

end