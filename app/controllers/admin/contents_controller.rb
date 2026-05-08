# frozen_string_literal: true

module Admin
  class ContentsController < ApplicationController
    before_action :set_grade
    before_action :set_recommend
    before_action :set_group

    def new
      @content = @content_group.contents.new
      authorize [:admin, @content], policy_class: Admin::ContentPolicy
    end

    def create
      @content = @content_group.contents.new(content_params)
      authorize [:admin, @content], policy_class: Admin::ContentPolicy

      if @content.save
        redirect_to admin_grade_recommend_content_group_path(@grade, @recommend, @content_group), , notice: '内容创建成功'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize [:admin, @content], policy_class: Admin::ContentPolicy
    end

    def update
      authorize [:admin, @content_group], policy_class: Admin::ContentGroupPolicy

      if @content_group.update(group_params)
        redirect_to admin_grade_recommend_content_groups_path(@grade, @recommend),notice: '内容分组更新成功'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize [:admin, @content_group], policy_class: Admin::ContentGroupPolicy

      @content_group.destroy
      redirect_to admin_grade_recommend_content_groups_path(@grade, @recommend),notice: '内容分组删除成功'
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

    def content_params
      params.require(:content).permit(
        :content_type,
        :img_url,
        :compilation_id,
        :book_id,
      ).merge(
        sn: params.dig(:content, :sn).to_i
      )
    end
  end
end
