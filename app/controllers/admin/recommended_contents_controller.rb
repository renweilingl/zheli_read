# frozen_string_literal: true

module Admin
  class RecommendedContentsController < ApplicationController
    before_action :set_grade
    before_action :set_recommended_content, only: [:show, :edit, :update, :destroy, :toggle_status]

    def index
      authorize [:admin, RecommendedContent], policy_class: Admin::RecommendedContentPolicy

      @recommended_contents = @grade.recommended_contents
                                  .sorted
                                  .paginate(page: params[:page], per_page: 15)
    end

    def show
      authorize [:admin, @recommended_content], policy_class: Admin::RecommendedContentPolicy
    end

    def new
      @recommended_content = @grade.recommended_contents.new
      authorize [:admin, @recommended_content], policy_class: Admin::RecommendedContentPolicy
    end

    def create
      @recommended_content = @grade.recommended_contents.new(recommended_content_params)
      authorize [:admin, @recommended_content], policy_class: Admin::RecommendedContentPolicy

      if @recommended_content.save
        redirect_to admin_grade_recommended_contents_path(@grade), notice: '推荐内容创建成功'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize [:admin, @recommended_content], policy_class: Admin::RecommendedContentPolicy
    end

    def update
      authorize [:admin, @recommended_content], policy_class: Admin::RecommendedContentPolicy

      if @recommended_content.update(recommended_content_params)
        redirect_to grade_recommended_contents_path(@grade), notice: '推荐内容更新成功'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize [:admin, @recommended_content], policy_class: Admin::RecommendedContentPolicy

      @recommended_content.destroy
      redirect_to grade_recommended_contents_path(@grade), notice: '推荐内容删除成功'
    end

    def toggle_status
      authorize [:admin, @recommended_content], policy_class: Admin::RecommendedContentPolicy

      @recommended_content.update(status: !@recommended_content.status)
      redirect_to grade_recommended_contents_path(@grade), notice: @recommended_content.status ? '已发布' : '已下架'
    end

    private

    def set_grade
      @grade = Grade.find(params[:grade_id])
    end

    def set_recommended_content
      @recommended_content = @grade.recommended_contents.find(params[:id])
    end

    def recommended_content_params
      params.require(:recommended_content).permit(
        :name,
      ).merge(
        status: params.dig(:recommended_content, :status) == 'true',
        sn: params.dig(:recommended_content, :sn).to_i
      )
    end
  end
end
