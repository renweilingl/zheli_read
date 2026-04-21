class FilesController < ApplicationController

  def upload_img 
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

end
