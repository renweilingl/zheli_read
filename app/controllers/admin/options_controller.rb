class Admin::OptionsController < ApplicationController
  before_action :require_login

  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

  def index
    authorize Category

    if params[:content_type] == "compilation"
      @title = "选择合辑"
      @name = "compilation_id"
      @opts = Compilation.all
    elsif params[:content_type] == "book"
      @title = "选择单本"
      @name = "book_id"
      @opts = Book.all
    elsif params[:content_type] == "recommend"
      @title = "选择推荐"
      @name = "recommend_id"
      @opts = Recommend.where(grade_id: params[:grade_id])
    elsif params[:content_type] == "rank"
      @title = "选择排行榜"
      @name = "rank_id"
      @opts = Rank.where(grade_id: params[:grade_id])
    end

    render json: { opts: render_to_string(partial: 'opts', layout: false), name: @name }
  end

end
