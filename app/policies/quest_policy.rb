class QuestPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.present?
  end

  def create?
    user&.organizer? || user&.admin?
  end

  def update?
    user&.admin? || record.user == user
  end

  def destroy?
    user&.admin?
  end

  def import?
    user&.organizer? || user&.admin?
  end

  class Scope < Scope
    def resolve
      return scope.all if user&.admin?
      return scope.where(user: user) if user&.organizer?
      scope.where(status: "launched", published_at: ..Time.current)
    end
  end
end