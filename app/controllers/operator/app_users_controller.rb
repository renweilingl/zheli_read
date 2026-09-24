class Operator::AppUsersController < ApplicationController
  before_action :require_login

  def index
    @per_page = params[:per_page] || 20

    @q = AppUser.ransack(params[:q])
    @app_users = @q.result.paginate(page: params[:page], per_page: @per_page)
  end

  def new_gift_vip
    @app_user = AppUser.find_by_id params[:id]
  end

  def add_gift_vip
    @app_user = AppUser.find_by_id params[:id]

    ds = params[:effective_days].to_i.days

    if @app_user.vip_expires_at.blank? || @app_user.vip_expires_at < Time.now
      @app_user.update(vip_expires_at: Time.now + ds, is_vip: true)
    else
      @app_user.update(vip_expires_at: @app_user.vip_expires_at + ds, is_vip: true)
    end

    flash[:success] = "会员赠送成功"
    redirect_to action: :index
  end
end
