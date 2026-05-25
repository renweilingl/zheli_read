namespace :db do
  desc "Fix missing durations for all chapters with media files"
  task fix_chapter_durations: :environment do
    chapters = Chapter.where.not(content_file_url: [nil, ""])
                      .where(content_file_type: %w[mp3 mp4 wav mov])
                      .where("duration IS NULL OR duration = 0")

    puts "Found #{chapters.count} chapters with missing durations"

    temp_dir = Rails.root.join("tmp", "uploads")
    FileUtils.mkdir_p(temp_dir)

    success_count = 0
    fail_count = 0

    chapters.find_each do |chapter|
      filename = File.basename(chapter.content_file_url)
      local_path = temp_dir.join(filename).to_s

      print "Chapter ##{chapter.id} (#{chapter.name}) - #{filename}... "

      begin
        # Download from OSS if not already present locally
        unless File.exist?(local_path)
          content = AliyunOss.instance.get(filename)
          File.binwrite(local_path, content)
        end

        if File.exist?(local_path) && File.size(local_path) > 0
          duration = MediaDurationService.extract_duration(local_path)
          if duration && duration > 0
            chapter.update(duration: duration)
            puts "#{duration}s (updated)"
            success_count += 1
          else
            puts "failed to extract duration"
            fail_count += 1
          end
        else
          puts "file empty or not found on OSS"
          fail_count += 1
        end
      rescue => e
        puts "error: #{e.message}"
        fail_count += 1
      ensure
        # Clean up downloaded file
        File.delete(local_path) if File.exist?(local_path)
      end
    end

    puts "\nDone! Success: #{success_count}, Failed: #{fail_count}"
  end
end
