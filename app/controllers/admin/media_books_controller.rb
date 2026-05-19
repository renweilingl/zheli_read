class Admin::MediaBooksController < ApplicationController
  before_action :require_login
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
    authorize Book
    @per_page = params[:per_page] || 20

    category_ids = Category.where(name: ["有声", "视频"]).pluck(:id)
    @q = Book.where(category_id: category_ids).ransack(params[:q])
    @picture_books = @q.result.paginate(page: params[:page], per_page: @per_page)

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
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def set_book
    @book = Book.find(params[:id])
  end
end
