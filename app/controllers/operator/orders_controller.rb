class Operator::OrdersController < ApplicationController
  before_action :require_login

  def index
    authorize Order

    @per_page = params[:per_page] || 20

    cond = params[:q] || {}

    @start_date = Time.now.to_date - 7.days
    @end_date = Time.now.to_date
    if params[:start_date].present?
      @start_date = params[:start_date]
    end

    if params[:end_date].present?
      @end_date = params[:end_date]
    end
    cond[:created_at_gteq] = @start_date
    cond[:created_at_lteq] = @end_date

    @q = Order.includes(:app_user).ransack(cond)
    @orders = @q.result.paginate(page: params[:page], per_page: @per_page)
  end
end
