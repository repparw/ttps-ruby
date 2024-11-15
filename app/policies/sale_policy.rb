class SalePolicy < ApplicationPolicy
  def index?
    user.admin? || user.manager? || user.employee?
  end

  def show?
    user.admin? || user.manager? || user.employee?
  end

  def create?
    user.admin? || user.manager? || user.employee?
  end

  def cancel?
    user.admin? || user.manager? || user.employee?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
