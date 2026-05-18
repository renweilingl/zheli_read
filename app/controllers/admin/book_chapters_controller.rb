class Admin::BookChaptersController < ApplicationController
  before_action :require_login
  before_action :set_book

  def index
    if request.xhr?
      resource = 
      items = @book.book_chapters.order("chapter_number asc").paginate(page: params[:page], per_page: params[:limit]).collect {|r|
        {id: r.id,
         chapter_name: r.chapter_name,
         start_page_number: r.start_page_number,
         chapter_number: r.chapter_number,
         is_free: r.is_free? ? "是" : "否",
         created_at: r.created_at.strftime('%Y-%m-%d'),
        }
      }
      render json: {data: items, code: 0, count: @book.book_chapters.size}
    end
  end

  def edit
  end

  def update
  end

  def update_sn
    @book.book_chapters.find(params[:id]).update(chapter_number: params[:sn])

    render json: {code: 0}
  end

  private

  def set_book
    @book = Book.find(params[:picture_book_id])
  end


end
