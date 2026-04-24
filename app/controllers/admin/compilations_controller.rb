# frozen_string_literal: true

class Admin::CompilationsController < ApplicationController
  before_action :set_compilation, only: [:show, :edit, :update, :destroy]

  def index
    authorize Compilation
    @compilations = Compilation
                  .search(params[:search])
                  .filter_by_status(params[:status])
                  .filter_by_sub_type(params[:sub_type])
                  .paginate(page: params[:page], per_page: params[:per_page] || 15)
  end

  def show
    authorize @compilation
  end

  def new
    @compilation = Compilation.new
    @compilation.min_age = 6
    @compilation.max_age = 8
    authorize @compilation
  end

  def create
    @compilation = Compilation.new(compilation_params)
    authorize @compilation

    if @compilation.save
      redirect_to admin_compilation_path(@compilation), notice: '合辑创建成功'
    else
      flash[:alert] = "合辑创建失败：#{@compilation.errors.full_messages.join(', ')}"
      logger.info @compilation.errors.full_messages.join(',')
      render :new
    end
  end

  def edit
    authorize Compilation
  end

  def update
    authorize Compilation

    if @compilation.update(compilation_params)
      redirect_to admin_collection_path(@collection), notice: '合辑更新成功'
    else
      render :edit
    end
  end

  # 删除合辑
  def destroy
    authorize Compilation
    @compilation.destroy
    redirect_to admin_collections_path, notice: '合辑删除成功'
  end


  # ===== 封面上传 =====
  # 上传banner (1500×932, ≤500KB)
  def upload_banner
    authorize Compilation
    upload_image('banner', 500)
  end

  # 上传横图封面 (1125×540, ≤500KB)
  def upload_landscape_cover
    authorize Compilation
    upload_image('landscape', 500)
  end

  # 上传长方形封面 (600×768, ≤300KB)
  def upload_portrait_cover
    authorize Compilation
    upload_image('portrait', 300)
  end

  # 上传正方形封面 (600×600, ≤300KB)
  def upload_square_cover
    authorize Compilation
    upload_image('square', 300)
  end

  # 上传图片简介
  def upload_intro_image
   authorize Compilation
   upload_image('intro', 5 * 1024)
  end

  private

  def set_compilation
    @compilation = Compilation.find(params[:id])
  end

  def compilation_params
    params.require(:compilation).permit(
      :name,
      :banner_image_url,
      :banner_image_name,
      :landscape_cover_url,
      :landscape_cover_name,

      :age_groups,
      :min_age,
      :max_age,
      :recommended_age,
      :themes,

      :sub_type,
      :editor_recommendation,
      :publisher,
      :total_count,
      :author,
      :tags,

      :intro_image_url,
      :intro_image_name,
      :content_description,
    )
  end
end
