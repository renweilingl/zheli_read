class Admin::CategoriesController < ApplicationController
  before_action :require_login
  before_action :set_category, only: [:show, :edit, :update, :destroy, :toggle_active]

  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

  # 分类列表
  def index
    authorize Category
    @per_page = params[:per_page] || 20

    @q = Category.ransack(params[:q])
    @categories = @q.result.paginate(page: params[:page], per_page: @per_page)

    respond_to do |format|
      format.html
      format.json { render json: {
        success: true,
        categories: @categories.map(&:as_json),
        pagination: {
          current_page: @categories.current_page,
          total_pages: @categories.total_pages,
          total_count: @categories.total_entries,
          per_page: @categories.per_page
        }
      }}
    end
  end

  # 显示分类详情
  def show
    authorize @category

    respond_to do |format|
      format.html
      format.json { render json: { success: true, category: @category.as_json } }
    end
  end

  # 新建分类
  def new
    authorize Category
    @category = Category.new
    @level = params[:level].to_i

    # 根据级别设置默认值
    if @level == Category::LEVEL_SECOND
      @category.level = Category::LEVEL_SECOND
    elsif @level == Category::LEVEL_THIRD
      @category.level = Category::LEVEL_THIRD
    elsif @level == Category::LEVEL_RECOMMENDED
      @category.level = Category::LEVEL_RECOMMENDED
    else
      @category.level = Category::LEVEL_GRADE
    end
  end

  # 创建分类
  def create
    authorize Category

    @category = Category.new(category_params)

    # 设置默认值
    @category.sn ||= 0
    @category.active = true if @category.active.nil?

    if @category.save
      respond_to do |format|
        format.html do
          flash[:notice] = "分类创建成功！"
          redirect_to admin_category_path(@category)
        end
        format.json { render json: { success: true, message: "分类创建成功", category: @category.as_json }, status: :created }
      end
    else
      respond_to do |format|
        format.html do
          @level = @category.level
          flash.now[:alert] = "分类创建失败：#{@category.errors.full_messages.join(', ')}"
          render :new, status: :unprocessable_entity
        end
        format.json { render json: { success: false, errors: @category.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  # 编辑分类
  def edit
    authorize @category
    @level = @category.level
  end

  # 更新分类
  def update
    authorize @category

    # 检查是否允许修改级别
    if params[:category][:level].present? && params[:category][:level].to_i != @category.level
      flash[:alert] = "分类级别不可修改，如需更改级别请删除后重新创建"
      redirect_to edit_admin_category_path(@category)
      return
    end

    if @category.update(category_params)
      respond_to do |format|
        format.html do
          flash[:notice] = "分类更新成功！"
          redirect_to admin_category_path(@category)
        end
        format.json { render json: { success: true, message: "分类更新成功", category: @category.as_json } }
      end
    else
      respond_to do |format|
        format.html do
          @level = @category.level
          flash.now[:alert] = "分类更新失败：#{@category.errors.full_messages.join(', ')}"
          render :edit, status: :unprocessable_entity
        end
        format.json { render json: { success: false, errors: @category.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  # 删除分类
  def destroy
    authorize @category

    if @category.destroy
      respond_to do |format|
        format.html do
          flash[:notice] = "分类删除成功！"
          redirect_to admin_categories_path(level: @category.level)
        end
        format.json { render json: { success: true, message: "分类删除成功" } }
      end
    else
      respond_to do |format|
        format.html do
          flash[:alert] = "分类删除失败"
          redirect_to admin_category_path(@category)
        end
        format.json { render json: { success: false, error: "分类删除失败" }, status: :unprocessable_entity }
      end
    end
  end

  # 切换启用状态
  def toggle_active
    authorize @category
    @category.update!(active: !@category.active)

    respond_to do |format|
      format.html { redirect_to request.referer || admin_categories_path }
      format.json { render json: { success: true, active: @category.active, message: @category.active ? "分类已启用" : "分类已禁用" } }
    end
  end

  # 批量操作
  def batch_action
    authorize Category

    action = params[:batch_action]
    category_ids = params[:category_ids] || []

    if category_ids.empty?
      respond_to do |format|
        format.html do
          flash[:alert] = "请选择要操作的分类"
          redirect_to admin_categories_path
        end
        format.json { render json: { success: false, error: "请选择要操作的分类" }, status: :bad_request }
      end
      return
    end

    @categories = Category.where(id: category_ids)

    case action
    when 'activate'
      @categories.update_all(active: true)
      message = "成功启用 #{@categories.count} 个分类"
    when 'deactivate'
      @categories.update_all(active: false)
      message = "成功禁用 #{@categories.count} 个分类"
    when 'delete'
      @categories.destroy_all
      message = "成功删除 #{@categories.count} 个分类"
    else
      message = "未知的操作"
    end

    respond_to do |format|
      format.html do
        flash[:notice] = message
        redirect_to admin_categories_path
      end
      format.json { render json: { success: true, message: message } }
    end
  end

  # 分类统计
  def statistics
    authorize Category
    @statistics = Category.statistics

    respond_to do |format|
      format.html
      format.json { render json: { success: true, statistics: @statistics } }
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :level, :sn, :description, :active)
  end
end
