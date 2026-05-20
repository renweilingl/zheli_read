class SplashAdsController < ApplicationController
  before_action :require_login
  before_action :set_splash_ad, only: [:show, :edit, :update, :destroy, :publish, :disable, :enable]
  
  def index
    authorize :splash_ad, :index?
    
    @splash_ads = SplashAd.all
    @splash_ads = @splash_ads.by_status(params[:status]) if params[:status].present?
    @splash_ads = @splash_ads.by_link_type(params[:link_type]) if params[:link_type].present?
    @splash_ads = @splash_ads.by_push_scope(params[:push_scope]) if params[:push_scope].present?
    @splash_ads = @splash_ads.ordered
    @splash_ads = @splash_ads.paginate(page: params[:page], per_page: 20)
    
    # 统计数据
    @stats = {
      total: SplashAd.count,
      active: SplashAd.active_now.count,
      scheduled: SplashAd.where(status: :scheduled).count,
      today_sends: SplashAd.where(status: [:active, :expired]).sum(:send_count),
      avg_delivery_rate: calculate_avg_delivery_rate
    }
    
    respond_to do |format|
      format.html
      format.json { render json: @splash_ads }
    end
  end
  
  def show
    authorize @splash_ad
    @stats = {
      send_count: @splash_ad.send_count,
      click_count: @splash_ad.click_count,
      delivery_rate: @splash_ad.delivery_rate_display,
      click_rate: @splash_ad.click_rate_display
    }
  end
  
  def new
    @splash_ad = SplashAd.new(
      ad_type: :app_open_popup,
      push_scope: :all_users,
      push_mode: :immediate,
      status: :draft
    )
    authorize @splash_ad
    load_associations
  end
  
  def create
    @splash_ad = SplashAd.new(splash_ad_params)
    @splash_ad.user = current_user
    authorize @splash_ad
    
    respond_to do |format|
      if @splash_ad.save
        format.html { redirect_to admin_splash_ad_path(@splash_ad), notice: '开屏广告创建成功。' }
        format.json { render json: { success: true, splash_ad: @splash_ad } }
      else
        load_associations
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { success: false, errors: @splash_ad.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
    authorize @splash_ad
    load_associations
  end
  
  def update
    authorize @splash_ad
    
    respond_to do |format|
      if @splash_ad.update(splash_ad_params)
        format.html { redirect_to admin_splash_ad_path(@splash_ad), notice: '开屏广告更新成功。' }
        format.json { render json: { success: true, splash_ad: @splash_ad } }
      else
        load_associations
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { success: false, errors: @splash_ad.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    authorize @splash_ad
    @splash_ad.destroy
    
    respond_to do |format|
      format.html { redirect_to admin_splash_ads_path, notice: '开屏广告已删除。' }
      format.json { render json: { success: true } }
    end
  end
  
  def publish
    authorize @splash_ad
    
    if @splash_ad.publish!
      respond_to do |format|
        format.html { redirect_to admin_splash_ad_path(@splash_ad), notice: '开屏广告已发布。' }
        format.json { render json: { success: true, status: @splash_ad.status } }
      end
    else
      respond_to do |format|
        format.html { redirect_to admin_splash_ad_path(@splash_ad), alert: '无法发布该广告，请检查时间和内容。' }
        format.json { render json: { success: false, errors: ['无法发布'] }, status: :unprocessable_entity }
      end
    end
  end
  
  def disable
    authorize @splash_ad
    @splash_ad.disable!
    
    respond_to do |format|
      format.html { redirect_to admin_splash_ad_path(@splash_ad), notice: '开屏广告已停用。' }
      format.json { render json: { success: true, status: @splash_ad.status } }
    end
  end
  
  def enable
    authorize @splash_ad
    @splash_ad.enable!
    
    respond_to do |format|
      format.html { redirect_to admin_splash_ad_path(@splash_ad), notice: '开屏广告已启用。' }
      format.json { render json: { success: true, status: @splash_ad.status } }
    end
  end
  
  def upload_image
    authorize :splash_ad, :create?
    
    file = params[:file]
    if file.blank?
      render json: { success: false, message: '请选择文件' }
      return
    end
    
    # 验证文件类型
    allowed_types = %w[image/jpeg image/png image/gif image/webp]
    unless allowed_types.include?(file.content_type)
      render json: { success: false, message: '只支持 JPG、PNG、GIF、WebP 格式的图片' }
      return
    end
    
    # 验证文件大小 (最大 5MB)
    if file.size > 5.megabytes
      render json: { success: false, message: '图片大小不能超过 5MB' }
      return
    end
    
    # 上传到 OSS
    begin
      oss_service = AliyunOssService.new
      url, filename = oss_service.upload(file, 'splash_ads')
      
      render json: {
        success: true,
        url: url,
        filename: filename,
        message: '上传成功'
      }
    rescue StandardError => e
      Rails.logger.error "Splash ad image upload failed: #{e.message}"
      render json: { success: false, message: '上传失败，请稍后重试' }
    end
  end
  
  def books_options
    authorize :splash_ad, :index?
    
    query = params[:q].to_s.strip
    books = Book.where.not(deleted_at: nil)
                .where('name LIKE ?', "%#{query}%")
                .limit(20)
                .select(:id, :name)
    
    render json: books.map { |b| { id: b.id, name: b.name } }
  end
  
  def categories_options
    authorize :splash_ad, :index?
    
    categories = Category.where.not(deleted_at: nil)
                         .select(:id, :name)
    
    render json: categories.map { |c| { id: c.id, name: c.name } }
  end
  
  private
  
  def set_splash_ad
    @splash_ad = SplashAd.find(params[:id])
  end
  
  def splash_ad_params
    params.require(:splash_ad).permit(
      :ad_type, :image_url, :image_name,
      :link_type, :link_url, :book_id, :category_id,
      :push_scope, :min_age, :max_age, :user_group,
      :push_mode, :scheduled_at,
      :start_time, :end_time,
      :status
    )
  end
  
  def load_associations
    @books = Book.where.not(deleted_at: nil).order(:name).limit(100)
    @categories = Category.where.not(deleted_at: nil).order(:name)
    @link_type_options = SplashAd.link_type_options
    @push_scope_options = SplashAd.push_scope_options
    @push_mode_options = SplashAd.push_mode_options
    @status_options = SplashAd.status_options
  end
  
  def calculate_avg_delivery_rate
    ads = SplashAd.where.not(send_count: 0)
    return 0 if ads.empty?
    
    total_rate = ads.sum(:delivery_rate)
    (total_rate / ads.count * 100).round(2)
  end
end
