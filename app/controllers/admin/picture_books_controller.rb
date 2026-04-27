# frozen_string_literal: true
class Admin::PictureBooksController < ApplicationController
  before_action :require_login
  before_action :set_book, only: [:show, :edit, :update, :destroy, :chapters, :new_chapter]

  def index
    authorize Book
    @per_page = params[:per_page] || 20

    @q = Book.ransack(params[:q])
    @picture_books = @q.result.paginate(page: params[:page], per_page: @per_page)

    @suppliers = Supplier.all
  end

  def show
    authorize @book
  end

  def chapters
    authorize @book
  end

  def new_chapter
    authorize @book
    @chapter = Chapter.new(book_id: @book.id)
  end

  def new
    @book = Book.new
    cat = Category.find_by(name: "绘本")
    @book.category_id = cat.id
    authorize @book
    @suppliers = Supplier.all
  end

  def create
    @book = Book.new(book_params)
    authorize @book
    @suppliers = Supplier.all

    if @book.save
      redirect_to admin_picture_books_path, notice: '图书创建成功'
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
      redirect_to admin_picture_books_path, notice: '图书更新成功'
    else
      render :edit
    end
  end

  def destroy
    authorize @book
    @book.destroy
    redirect_to admin_picture_books_path, notice: '图书删除成功'
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
      :supplier_id,
      :category_id,
      :grade_ids => []
    )
  end
end
