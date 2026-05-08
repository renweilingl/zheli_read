# frozen_string_literal: true

module Admin
  class ContentsController < ApplicationController
    before_action :require_login
    before_action :set_grade
    before_action :set_recommend
    before_action :set_group
    before_action :set_content, only: [:edit, :update, :destroy]

    def new
      @content = @content_group.contents.new
      if @content_group.group_type == "author_display"
        @content.content_type = "author_display"
      else
        @content.content_type = "compilation"
      end
      authorize [:admin, @content], policy_class: Admin::ContentPolicy
    end

    def create
      @content = @content_group.contents.new(content_params)
      authorize [:admin, @content], policy_class: Admin::ContentPolicy

      if @content.save
        redirect_to admin_grade_recommend_content_group_path(@grade, @recommend, @content_group), notice: '内容创建成功'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize [:admin, @content], policy_class: Admin::ContentPolicy
    end

    def update
      authorize [:admin, @content], policy_class: Admin::ContentPolicy

      if @content.update(content_params)
        redirect_to admin_grade_recommend_content_group_path(@grade, @recommend, @content_group), notice: '内容更新成功'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize [:admin, @content], policy_class: Admin::ContentPolicy

      @content.destroy
      redirect_to admin_grade_recommend_content_group_path(@grade, @recommend, @content_group), notice: '内容删除成功'
    end

    private
    def set_grade      #年级
      @grade = Grade.find(params[:grade_id])
    end

    def set_recommend  #推荐
      @recommend = Recommend.find(params[:recommend_id])
    end

    def set_group      #分组
      @content_group = ContentGroup.find(params[:content_group_id])
    end

    def set_content
      @content = Content.find(params[:id])
    end

    def content_params
      params.require(:content).permit(
        :content_type,
        :img_url,
        :compilation_id,
        :book_id,
        :recommend_id,
        :author_id
      ).merge(
        sn: params.dig(:content, :sn).to_i
      )
    end
  end
end
