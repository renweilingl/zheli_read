class Admin::ContentsController < ApplicationController
  before_action :set_content, only: [:show, :edit, :update, :destroy]


  def index
    #authorize Content
    @per_page = params[:per_page] || 20

    @q = Content.ransack(params[:q])
    @contents = @q.result.paginate(page: params[:page], per_page: @per_page)

    respond_to do |format|
      format.html
      format.json { render json: {
        success: true,
        categories: @contents.map(&:as_json),
        pagination: {
          current_page: @contents.current_page,
          total_pages: @contents.total_pages,
          total_count: @contents.total_entries,
          per_page: @contents.per_page
        }
      }}
    end
  end

  def new
    @content = Content.new
    grade = Category.find_by(name: "三年级")
    @content.grade_level = grade.id
  end

  def create
    @content = Content.new(content_params)

    if @content.save
      redirect_to admin_contents_path, notice: '内容创建成功'
    else
      respond_to do |format|
        format.html do
          flash.now[:alert] = "内容创建失败：#{@content.errors.full_messages.join(', ')}"
          render :new, status: :unprocessable_entity
        end
        format.json { render json: { success: false, errors: @content.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def show
    @content.increment_view_count! if @content.published?
  end

  def edit
    redirect_to admin_contents_path, alert: '该内容无法编辑' unless @content.can_edit?
  end

  def update
    if @content.update(content_params)
      redirect_to admin_content_path(@content), notice: '内容更新成功'
    else
      render :edit
    end
  end

  def destroy
    if @content.can_delete?
      @content.destroy
      redirect_to admin_contents_path, notice: '内容删除成功'
    else
      redirect_to admin_contents_path, alert: '该内容无法删除'
    end
  end

  # 文件上传
  def upload
    file = params[:file]

    if file.blank?
      render json: { code: 1, msg: '请选择要上传的文件' }
      return
    end

    extension = File.extname(file.original_filename).downcase.delete('.')
    allowed_extensions = %w[epub pdf mp3 mp4]

    unless allowed_extensions.include?(extension)
      render json: { code: 1, msg: '不支持的文件格式，请上传 epub、pdf、mp3 或 mp4 格式的文件' }
      return
    end

    if file.size > 200.megabytes
      render json: { code: 1, msg: "文件大小超过限制（最大 #{200.megabytes / 1.megabyte}MB）" }
      return
    end

    begin
      # 生成唯一文件名
      timestamp = Time.now.strftime('%Y%m%d%H%M%S')
      random_str = SecureRandom.hex(8)
      new_filename = "#{timestamp}_#{random_str}.#{extension}"

      tmp_file_path = file.tempfile.path
      mime = `file --brief --mime-type "#{tmp_file_path}"`.strip

      oss_path = AliyunOss.instance.put(new_filename, File.open(file.path), {'content_type': mime})

      render json: {
        code: 0,
        msg: '上传成功',
        data: {
          file_url: new_filename,
          file_type: extension,
          file_name: file.original_filename,
          file_size: file.size,
          file_size_desc: ActiveSupport::NumberHelper.number_to_human_size(file.size)
        }
      }
    rescue => e
      Rails.logger.error "文件上传失败: #{e.message}"
      render json: { code: 1, msg: '文件上传失败，请重试' }
    end
  end

  private

  def set_content
    @content = Content.find(params[:id])
  end

  def content_params
    params.require(:content).permit(
      :title,
      :description,
      :tags,
      :file_type,
      :file_url,
      :file_name,
      :file_size,
      :duration,
      :third_level,
      :second_level,
      :grade_level,
      :status
    )
  end
end
