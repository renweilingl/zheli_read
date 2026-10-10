class Operator::OrdersController < ApplicationController
  before_action :require_login

  def index
    authorize Order

    @per_page = params[:per_page] || 20

    @q = Order.includes(:app_user).ransack(params[:q])
    @orders = @q.result.paginate(page: params[:page], per_page: @per_page)
  end
end
