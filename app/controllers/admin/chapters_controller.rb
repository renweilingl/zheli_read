class Admin::ChaptersController < ApplicationController
  before_action :require_login

  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

  def destroy
    @chapter  = Chapter.find(params[:id])
    authorize @chapter
    book_id = @chapter.book_id

    @chapter.destroy
    flash[:notice] = "内容删除成功！"

    redirect_to chapters_admin_picture_book_path(book_id)
  end
end
