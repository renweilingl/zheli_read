# frozen_string_literal: true

module Admin
  class ContentPolicy < ApplicationPolicy
    attr_reader :user, :content

    def initialize(user, content)
      @user = user
      @content = content
    end

    # 所有用户都可以查看内容列表
    def index?
      true
    end

    # 所有用户都可以查看单个内容
    def show?
      true
    end

    # 超级管理员和编辑可以创建内容
    def create?
      user.super_admin? || user.editor?
    end

    # 超级管理员和编辑可以更新内容
    def update?
      user.super_admin? || user.editor?
    end

    # 超级管理员可以删除内容
    def destroy?
      user.super_admin?
    end

    # 发布内容
    def publish?
      user.super_admin? || user.editor?
    end

    # 下线内容
    def offline?
      user.super_admin? || user.editor?
    end

    # 审核内容
    def approve?
      user.super_admin?
    end

    # 驳回内容
    def reject?
      user.super_admin?
    end

    # 文件上传
    def upload?
      user.super_admin? || user.editor?
    end

    class Scope < Scope
      def resolve
        if user.super_admin? || user.editor?
          scope.all
        else
          scope.none
        end
      end
    end
  end
end
