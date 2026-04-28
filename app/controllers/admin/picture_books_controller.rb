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

    @chapters = @book.chapters.paginate(page: params[:page], per_page: @per_page)
  end

  def new_chapter
    authorize @book
    @chapter = Chapter.new(book_id: @book.id, is_published: true)
  end

  def add_chapter
    rd = Chapter.where(book_id: params[:chapter][:book_id]).order("sn desc").first
    sn = rd.nil? ? 1 : rd.sn + 1

    chapter = Chapter.create(params[:chapter].permit!.merge!(sn: sn))
    redirect_to chapters_admin_picture_book_path(chapter.book_id)
  end

  def edit_chapter
    @chapter = Chapter.find_by_id params[:id]
  end

  def update_chapter
    chapter = Chapter.find_by_id params[:id]
    chapter.update(params[:chapter].permit!)
    redirect_to chapters_admin_picture_book_path(chapter.book_id)
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
      redirect_to :admin_picture_books, notice: '绘本创建成功'
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
      redirect_to admin_picture_books_path, notice: '绘本更新成功'
    else
      render :edit
    end
  end

  def destroy
    authorize @book
    @book.destroy
    redirect_to admin_picture_books_path, notice: '绘本删除成功'
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
