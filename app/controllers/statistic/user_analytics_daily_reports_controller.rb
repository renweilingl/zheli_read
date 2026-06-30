class Statistic::UserAnalyticsDailyReportsController < ApplicationController
  before_action :require_login
  before_action :get_data

  def index
  end

  private
  def get_data
  end
end
