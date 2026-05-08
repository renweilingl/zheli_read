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
    #else
    #  @title = "选择推荐"
    #  @name = "recommend_id"
    #  @opts = Recommend.all
    end

    render json: { opts: render_to_string(partial: 'opts', layout: false) }
  end

end
