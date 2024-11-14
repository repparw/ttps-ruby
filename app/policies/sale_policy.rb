class SalePolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.present?
  end

  def create?
    user.present?
  end

  def cancel?
    user.admin? || user.manager? ||
      (user.employee? && record.user_id == user.id)
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
