class RankContentsController < ApplicationController
  before_action :require_login
  before_action :set_grade
  before_action :set_rank

  def index
    authorize Rank

    @rank_contents = @rank.rank_contents.order("sn asc")
  end

  def new
  end

  def create
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
end
