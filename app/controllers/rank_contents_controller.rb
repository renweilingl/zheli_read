class RankContentsController < ApplicationController
  before_action :require_login
  before_action :set_grade
  before_action :set_rank

  def index
    authorize RankContent

    @rank_contents = @rank.rank_contents.order("sn asc")
  end

  def new
    rank_content = @rank.rank_contents.order("sn desc").first
    sn = rank_content.nil? ? 1 : rank_content.sn + 1
    @content = @rank.rank_contents.new(sn: sn)

    authorize @content
  end

  def create
    @content = @rank.rank_contents.new(content_params)
    authorize @content

    if @content.save
      redirect_to grade_rank_rank_contents_path(@grade, @rank), notice: '内容创建成功'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def set_grade
    @grade = Grade.find(params[:grade_id])
  end

  def set_rank
    @rank = Rank.find(params[:rank_id])
  end

  def content_params
    params.require(:rank_content).permit(
        :content_type,
        :compilation_id,
        :book_id,
      ).merge(
        sn: params.dig(:content, :sn).to_i
      )
  end
end
