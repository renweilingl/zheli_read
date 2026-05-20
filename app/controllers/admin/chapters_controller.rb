class Admin::ChaptersController < ApplicationController
  before_action :require_login
  before_action :set_book

  def index
    authorize Book

    if request.xhr?
      items = @book.chapters.order("sn asc").paginate(page: params[:page], per_page: params[:limit]).collect {|r|
        {id: r.id,
         book_id: r.book_id,
         name: r.name,
         content_file_name: r.content_file_name,
         sn: r.sn,
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
    authorize @book

    chapter = @book.chapters.create(params[:chapter].permit!)

    redirect_to admin_media_book_chapters_path(@book), notice: '内容创建成功'
  end

  def edit
    authorize @book

    @chapter = @book.chapters.find(params[:id])
  end

  def update
    authorize @book

    chapter = @book.chapters.find(params[:id])
    chapter.update(params[:chapter].permit!)

    redirect_to admin_media_book_chapters_path(@book), notice: '内容修改成功'
  end

  def update_sn
    @book.chapters.find(params[:id]).update(sn: params[:sn])

    render json: {code: 0}
  end

  def destroy
    authorize @book

    @chapter  = Chapter.find(params[:id])

    @chapter.destroy
    flash[:notice] = "内容删除成功！"

    redirect_to chapters_admin_picture_book_path(@book)
  end

  private
  def set_book
    @book = Book.find(params[:media_book_id])
  end
end
