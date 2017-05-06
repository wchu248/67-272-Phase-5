class Ability
  include CanCan::Ability

  def initialize(user)
    # set user to new User if not logged in
    user ||= User.new # i.e., a guest user
    alias_action :create, :read, :update, :to => :create_edit_read
    alias_action :create, :read, :update, :destroy, :to => :crud
    if user.role? :admin
      # admins can do everything
      can :manage, :all
    elsif user.role? :manager
      can :read, :all
      can :create_edit_read, User do |u|
        # can create/edit/read EMPLOYEE data
        u.role != 'customer'
      end
      can :crud, Item
    elsif user.role? :shipper
      can :show, User do |u|
        u.id == user.id
      end
      can :update, User do |u|
        u.id == user.id
      end
      can :read, Item
      can :read, Order
    elsif user.role? :customer
      can :show, User do |u|
        u.id == user.id
      end
      can :update, User do |u|
        u.id == user.id
      end
      can :read, Item
      can :create, School
      # can see their own orders
      can :read, Order do |o|
        o.user_id == user.id
      end
      # can place an order for themselves
      can :create, Order
      # can cancel their own orders
      can :destroy, Order do |o|
        o.user_id == user.id
      end
    else
      # guest action
      can :read, Item
      can :create, User
    end
  end

end