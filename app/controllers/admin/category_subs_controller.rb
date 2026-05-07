# frozen_string_literal: true

module Admin
  class CategorySubsController < ApplicationController
    before_action :set_category
    before_action :set_sub, only: [:edit, :update, :destroy]

    def index
      authorize [:admin, CategorySub], policy_class: Admin::CategorySubPolicy

      @subs = @category.category_subs.sorted
    end

    def new
      @sub = @category.category_subs.new
      authorize [:admin, @sub], policy_class: Admin::CategorySubPolicy
    end

    def create
      @sub = @category.category_subs.new(sub_params)
      authorize [:admin, @sub], policy_class: Admin::CategorySubPolicy

      if @sub.save
        render json: {
          success: true,
          notice: '子类创建成功',
          data: {
            id: @sub.id,
            name: @sub.name,
            icon: @sub.icon,
            icon_url: @sub.icon_url,
            sort_order: @sub.sort_order
          }
        }
      else
        render json: { success: false, error: @sub.errors.full_messages.join(', ') }
      end
    end

    def edit
      authorize [:admin, @sub], policy_class: Admin::CategorySubPolicy
    end

    def update
      authorize [:admin, @sub], policy_class: Admin::CategorySubPolicy

      if @sub.update(sub_params)
        render json: {
          success: true,
          notice: '子类更新成功',
          data: {
            id: @sub.id,
            name: @sub.name,
            icon: @sub.icon,
            icon_url: @sub.icon_url,
            sort_order: @sub.sort_order
          }
        }
      else
        render json: { success: false, error: @sub.errors.full_messages.join(', ') }
      end
    end

    def destroy
      authorize [:admin, @sub], policy_class: Admin::CategorySubPolicy

      @sub.destroy
      render json: { success: true, notice: '子类删除成功' }
    end

    private
    def set_category
      @category = Category.find(params[:category_id])
    end

    def set_sub
      @sub = @category.category_subs.find(params[:id])
    end

    def sub_params
      params.require(:category_sub).permit(
        :name,
        :icon,
      )
    end
  end
end
