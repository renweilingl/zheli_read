class ChapterPolicy < ApplicationPolicy
  attr_reader :user, :chapter

  def initialize(user, chapter)
    @user = user
    @chapter = chapter
  end

  def destroy?
    return false unless user.super_admin? || user.editor?
    true
  end

  class Scope < Scope
    def resolve
      if user.super_admin?
        scope.all
      else
        scope.active
      end
    end
  end
end
