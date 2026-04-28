class FileUploadJob < ApplicationJob
  queue_as :zheli_high

  def perform(oss_key, file_path, mime)
    file = File.open(file_path)
    oss_path = AliyunOss.instance.put(oss_key, file, {'content_type': mime})
    logger.info "FileUploadJob oss_path: #{oss_path}"

    file.close
    cleanup_temp_file(file_path)
  end

  def cleanup_temp_file(file_path)
    return unless file_path.start_with?('/tmp/') || file_path.include?('tmp/uploads')

    if File.exist?(file_path)
      File.delete(file_path)
      Rails.logger.info "Cleaned up temp file: #{file_path}"
    end
  rescue => e
    Rails.logger.warn "Cleanup temp file failed: #{e.message}"
  end
end
