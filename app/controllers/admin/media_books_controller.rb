class Admin::MediaBooksController < ApplicationController
  before_action :require_login
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
    authorize Book
    @per_page = params[:per_page] || 20

    category_ids = Category.where(name: ["有声", "视频"]).pluck(:id)
    @q = Book.where(category_id: category_ids).ransack(params[:q])
    @books = @q.result.paginate(page: params[:page], per_page: @per_page)

    @suppliers = Supplier.all 
  end

  def new
    @book = Book.new
    cat = Category.find_by(name: "有声")
    @book.category_id = cat.id
    authorize @book
    @suppliers = Supplier.all
  end

  def create
    @book = Book.new(book_params)
    authorize @book
    @suppliers = Supplier.all

    if @book.save
      redirect_to :admin_media_books, notice: '图书创建成功'
    else
      render :new
    end
  end

  def show
  end

  def edit
    authorize @book
    @suppliers = Supplier.all
  end

  def update
    authorize @book
    @suppliers = Supplier.all

    if @book.update(book_params)
      redirect_to admin_media_books_path, notice: '图书更新成功'
    else
      render :edit
    end
  end

  def destroy
    @book.destroy
    redirect_to :admin_media_books, notice: '图书删除成功'
  end

  private
  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(
      :name,
      :cover_image_url,
      :supplier_id,
      :category_id,
      :book_level_id,
      :author_id,
      :file_url,
      :file_name,
      :file_type,
      :is_free,
      :broadcaster,
      :content_description,
      :grade_ids => [],
      :category_sub_ids => []
    )
  end
end
