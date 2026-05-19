class Admin::ChaptersController < ApplicationController
  before_action :require_login
  before_action :set_book

  def index
    authorize Book

    if request.xhr?
      items = @book.chapters.order("sn asc").paginate(page: params[:page], per_page: params[:limit]).collect {|r|
        {id: r.id,
         book_id: r.book_id,
         content_file_name: r.content_file_name,
         sn: r.is_free,
         is_free: r.is_free,
         is_published: r.is_published,
         created_at: r.created_at.strftime('%Y-%m-%d'),
        }
      }
      render json: {data: items, code: 0, count: @book.book_chapters.size}
    end
  end

  def new
    authorize @book

    chapter = @book.chapters.order("sn desc").first
    sn = chapter.nil? ? 1 : chapter.sn + 1

    @chapter = @book.chapters.new(is_published: true, sn: sn)
  end

  def create
    @chapter = Chapter.new(book_id: @book.id, is_published: true)
  end

  def edit
  end

  def update
  end

  def destroy
    @chapter  = Chapter.find(params[:id])
    authorize @chapter
    book_id = @chapter.book_id

    @chapter.destroy
    flash[:notice] = "内容删除成功！"

    redirect_to chapters_admin_picture_book_path(book_id)
  end

  private
  def set_book
    @book = Book.find(params[:media_book_id])
  end
end
