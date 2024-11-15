class ProductPolicy < ApplicationPolicy
  def index?
    user.admin? || user.manager? || user.employee?
  end

  def show?
    user.admin? || user.manager? || user.employee?
  end

  def create?
    user.admin? || user.manager? || user.employee?
  end

  def update?
    user.admin? || user.manager? || user.employee?
  end

  def destroy?
    user.admin? || user.manager? || user.employee?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
