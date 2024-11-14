# app/policies/user_policy.rb
class UserPolicy < ApplicationPolicy
  def index?
    user.admin? || user.manager?
  end

  def show?
    user.admin? || user.manager? || user.id == record.id
  end

  def create?
    user.admin? || user.manager?
  end

  def update?
    return false if record.admin? && !user.admin?

    user.admin? || user.manager? || user.id == record.id
  end

  def destroy?
    return false if record.admin? && !user.admin?

    user.admin? || (user.manager? && !record.admin?)
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user.manager?
        scope.where.not(role: :admin)
      else
        scope.none
      end
    end
  end
end
