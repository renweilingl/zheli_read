# frozen_string_literal: true
class Admin::BooksController < ApplicationController
  before_action :require_login
  before_action :set_book, only: [:show, :edit, :update, :destroy, :publish, :offline, :toggle_lock]

  def index
    authorize Book
    @books = Book
            .search(params[:search])
            .filter_by_status(params[:status])
            .filter_by_payment_type(params[:payment_type])
            .filter_by_book_type(params[:book_type])
            .filter_by_supplier(params[:supplier_id])
            .paginate(page: params[:page], per_page: params[:per_page] || 15)

    @suppliers = Supplier.all
  end

  def show
    authorize @book
  end

  def new
    @book = Book.new
    @book.min_age = 0
    @book.max_age = 99
    @book.purchasable = true
    authorize @book
    @suppliers = Supplier.all
  end

  def create
    @book = Book.new(book_params)
    @book.user = current_user
    authorize @book
    @suppliers = Supplier.active_suppliers

    if @book.save
      redirect_to admin_book_path(@book), notice: '绘本创建成功'
    else
      render :new
    end
  end

  def edit
    authorize @book
    @suppliers = Supplier.active_suppliers
  end

  def update
    authorize @book
    @suppliers = Supplier.active_suppliers

    if @book.update(book_params)
      redirect_to admin_book_path(@book), notice: '绘本更新成功'
    else
      render :edit
    end
  end

  def destroy
    authorize @book
    @book.destroy
    redirect_to admin_books_path, notice: '绘本删除成功'
  end

  def publish
    authorize @book

    if @book.publish!
      redirect_to admin_book_path(@book), notice: '绘本已上线'
    else
      redirect_to admin_book_path(@book), alert: '上线失败'
    end
  end

  def offline
    authorize @book

    if @book.offline!
      redirect_to admin_book_path(@book), notice: '绘本已下线'
    else
      redirect_to admin_book_path(@book), alert: '下线失败'
    end
  end

  def toggle_lock
    authorize @book

    @book.update(locked: !@book.locked)
    notice = @book.locked? ? '绘本已锁定' : '绘本已解锁'

    redirect_to admin_book_path(@book), notice: notice
  end

  def upload_cover
    authorize Book

    file = params[:file]
    if file.blank?
      render json: { success: false, message: '请选择文件' }
      return
    end

    allowed_types = %w[image/jpeg image/jpg image/png image/gif image/webp]
    unless allowed_types.include?(file.content_type)
      render json: { success: false, message: '仅支持 JPG、PNG、GIF、WebP 格式' }
      return
    end

    # 验证文件大小 (5MB)
    if file.size > 5.megabytes
      render json: { success: false, message: '文件大小不能超过 5MB' }
      return
    end

    extension = File.extname(file.original_filename).downcase.delete('.')
    timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    random_str = SecureRandom.hex(8)                                           
    new_filename = "#{timestamp}_#{random_str}.#{extension}"                   
                                                                                 
    tmp_file_path = file.tempfile.path                                         
    mime = `file --brief --mime-type "#{tmp_file_path}"`.strip                 
                                                                                 
    oss_path = AliyunOss.instance.put(new_filename, File.open(file.path), {'content_type': mime})

    render json: {
      success: true,
      url: oss_path,
      preivew_url: FileMap.new(oss_path, "img").secrity_src,
      name: file.original_filename,
      size: file.size
    }
  end

  # 上传图片简介
  def upload_intro_image
    authorize Book

    file = params[:file]
    if file.blank?
      render json: { success: false, message: '请选择文件' }
      return
    end

    # 验证文件类型
    allowed_types = %w[image/jpeg image/jpg image/png image/gif image/webp]
    unless allowed_types.include?(file.content_type)
      render json: { success: false, message: '仅支持 JPG、PNG、GIF、WebP 格式' }
      return
    end

    # 验证文件大小 (5MB)
    if file.size > 5.megabytes
      render json: { success: false, message: '文件大小不能超过 5MB' }
      return
    end

    # TODO: 上传到 OSS 或本地存储
    url = "/uploads/books/intro/#{SecureRandom.uuid}#{File.extname(file.original_filename)}"

    render json: {
      success: true,
      url: url,
      name: file.original_filename,
      size: file.size
    }
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(
      # 核心基础信息
      :name,
      :cover_image_url,
      :book_type,
      :min_age,
      :max_age,
      :recommended_age,
      #:categories => [],
      #:themes => [],
      :supplier_id,
      # 版权与出版信息
      :has_copyright,
      :payment_type,
      :price,
      :copyright_start_date,
      :copyright_end_date,
      :isbn,
      :publisher,

      # 合辑与关联属性
      #:collections => [],
      :main_collection_id,
      :has_isbn,

      # 作者/译者信息
      :author,
      :translator,
      :compiler,
      :illustrator,
      :editor_in_chief,
      #:awards => [],

      # 内容与展示信息
      :intro_image_url,
      :intro_image_name,
      :quote_current_owner,
      :image_description,
      :description,
      :orientation,
      :purchasable,
      :editor_recommendation,
      :detail_recommendation,
      :page_count,
      :full_trial_read,
      :trial_page_count,
      :word_count,
      :remark,

      # 状态与数据设置
      :scheduled_online_at,
      :locked,
      :status,
      :base_read_count,
      :base_rating_count,
      :base_rating,

      # 标签系统
      :level_one_tags => [],
      :level_two_tags => []
    )
  end
end
