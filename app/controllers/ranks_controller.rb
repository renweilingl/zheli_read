class RanksController < ApplicationController
  before_action :require_login
  before_action :set_grade

  def index
  end

  def new
  end

  def create
  end

  private
  def set_grade
    @grade = Grade.find(params[:grade_id])
  end
end
