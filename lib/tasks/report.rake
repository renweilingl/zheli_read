namespace :reports do
  desc "任务测试"
  task :job_test => :environment do
    Chapter.where(content_file_type: "mp4").each do |x|
      next if x.ld_file_path.blank?

      x.update(ld_file_path: x.ld_file_path.gsub("mp4.mp4", "mp4"), hd_file_path: x.hd_file_path.gsub("mp4.mp4", "mp4"),  sd_file_path: x.sd_file_path.gsub("mp4.mp4", "mp4"))
    end
  end
end
