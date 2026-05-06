# frozen_string_literal: true

module Admin
  class ContentGroupsController < ApplicationController
    before_action :set_grade
    before_action :set_recommend
    before_action :set_group, only: [:show, :edit, :update, :destroy, :toggle_status]

    def index
      authorize [:admin, ContentGroup], policy_class: Admin::ContentGroupPolicy

      @content_groups = @recommend.content_groups.sorted.paginate(page: params[:page], per_page: 15)
    end

    def show
      authorize [:admin, @recommend], policy_class: Admin::RecommendPolicy
    end

    def new
      @recommend = @grade.recommends.new
      authorize [:admin, @recommend], policy_class: Admin::RecommendPolicy
    end

    def create
      @recommend = @grade.recommends.new(recommend_params)
      authorize [:admin, @recommend], policy_class: Admin::RecommendPolicy

      if @recommend.save
        redirect_to admin_grade_recommends_path(@grade), notice: '推荐内容创建成功'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize [:admin, @recommend], policy_class: Admin::RecommendPolicy
    end

    def update
      authorize [:admin, @recommend], policy_class: Admin::RecommendPolicy

      if @recommend.update(recommend_params)
        redirect_to admin_grade_recommends_path(@grade), notice: '推荐内容更新成功'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize [:admin, @recommend], policy_class: Admin::RecommendPolicy

      @recommend.destroy
      redirect_to grade_recommends_path(@grade), notice: '推荐内容删除成功'
    end

    def toggle_status
      authorize [:admin, @recommend], policy_class: Admin::RecommendPolicy

      @recommend.update(status: !@recommend.status)
      redirect_to admin_grade_recommends_path(@grade), notice: @recommend.status ? '已发布' : '已下架'
    end

    private
    def set_grade
      @grade = Grade.find(params[:grade_id])
    end

    def set_recommend
      @recommend = Recommend.find(params[:recommend_id])
    end

    def set_group
      @content_group = @recommend.content_group.find(params[:id])
    end

    def group_params
      params.require(:recommend).permit(
        :name,
        :group_type
      ).merge(
        sn: params.dig(:content_group, :sn).to_i
      )
    end
  end
end
