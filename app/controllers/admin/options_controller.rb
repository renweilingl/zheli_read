class Admin::OptionsController < ApplicationController
  before_action :require_login

  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

  def index
    authorize Category

    case params[:content_type]
    when "compilation"
      @title = "选择合辑"
      @name = "compilation_id"
      @opts = Compilation.all
    when "book"
      @title = "选择图书"
      @name = "book_id"
      @opts = Book.all
    when "comic"
      @title = "选择漫画"
      @name = "book_id"
      @opts = Book.all
    when "audio"
      @title = "选择有声"
      @name = "book_id"
      @opts = Book.all
    when "video"
      @title = "选择视频"
      @name = "book_id"
      @opts = Book.all
    when "recommend"
      @title = "选择推荐"
      @name = "recommend_id"
      @opts = Recommend.where(grade_id: params[:grade_id])
    when "rank"
      @title = "选择排行榜"
      @name = "rank_id"
      @opts = Rank.where(grade_id: params[:grade_id])
    end

    render json: { opts: render_to_string(partial: 'opts', layout: false), name: @name }
  end

end
