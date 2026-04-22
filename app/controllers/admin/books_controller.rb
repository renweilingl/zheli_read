# frozen_string_literal: true
class Admin::BooksController < ApplicationController
  before_action :require_login
  before_action :set_book, only: [:show, :edit, :update, :destroy, :publish, :offline, :toggle_lock]

  def index
    authorize Book
    @per_page = params[:per_page] || 20

    @q = Book.ransack(params[:q])
    @books = @q.result.paginate(page: params[:page], per_page: @per_page)

    respond_to do |format|
      format.html
      format.json { render json: {
        success: true,
        categories: @books.map(&:as_json),
        pagination: {
          current_page: @books.current_page,
          total_pages: @books.total_pages,
          total_count: @books.total_entries,
          per_page: @books.per_page
        }
      }}
    end
    @suppliers = Supplier.all
  end

  def show
    authorize @book
  end

  def new
    @book = Book.new
    @book.min_age = 8
    @book.max_age = 12
    @book.purchasable = true
    authorize @book
    @suppliers = Supplier.all
  end

  def create
    @book = Book.new(book_params)
    authorize @book
    @suppliers = Supplier.all

    if @book.save
      redirect_to admin_book_path(@book), notice: '绘本创建成功'
    else
      render :new
    end
  end

  def edit
    authorize @book
    @suppliers = Supplier.all
  end

  def update
    authorize @book
    @suppliers = Supplier.all

    if @book.update(book_params)
      redirect_to admin_book_path(@book), notice: '绘本更新成功'
    else
      render :edit
    end
  end

  def destroy
    authorize @book
    @book.destroy
    redirect_to admin_books_path, notice: '绘本删除成功'
  end

  def publish
    authorize @book

    if @book.publish!
      redirect_to admin_book_path(@book), notice: '绘本已上线'
    else
      redirect_to admin_book_path(@book), alert: '上线失败'
    end
  end

  def offline
    authorize @book

    if @book.offline!
      redirect_to admin_book_path(@book), notice: '绘本已下线'
    else
      redirect_to admin_book_path(@book), alert: '下线失败'
    end
  end

  def toggle_lock
    authorize @book

    @book.update(locked: !@book.locked)
    notice = @book.locked? ? '绘本已锁定' : '绘本已解锁'

    redirect_to admin_book_path(@book), notice: notice
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(
      # 核心基础信息
      :name,
      :cover_image_url,
      :book_type,
      :min_age,
      :max_age,
      :recommended_age,
      :lan_type,
      :cat_display,
      #:categories => [],
      #:themes => [],
      :supplier_id,
      # 版权与出版信息
      :has_copyright,
      :payment_type,
      :price,
      :copyright_start_date,
      :copyright_end_date,
      :isbn,
      :publisher,

      # 合辑与关联属性
      #:collections => [],
      :main_collection_id,
      :has_isbn,

      # 作者/译者信息
      :author,
      :translator,
      :compiler,
      :illustrator,
      :editor_in_chief,
      #:awards => [],

      # 内容与展示信息
      :intro_image_url,
      :intro_image_name,
      :quote_current_owner,
      :image_description,
      :description,
      :orientation,
      :purchasable,
      :editor_recommendation,
      :detail_recommendation,
      :page_count,
      :full_trial_read,
      :trial_page_count,
      :word_count,
      :remark,

      # 状态与数据设置
      :scheduled_online_at,
      :locked,
      :status,
      :base_read_count,
      :base_rating_count,
      :base_rating,

      # 标签系统
      :level_one_tags => [],
      :level_two_tags => []
    )
  end
end
