class GradesController < ApplicationController
  before_action :require_login

  def index
    authorize Grade
    @grades = Grade.all.order("id asc")
  end

end
