namespace :reports do
  desc "任务测试"
  task :job_test => :environment do
    reader = PDF::Reader.new("和大人一起读1.pdf")

    puts reader.info
    puts "PDF 版本: #{reader.pdf_version}"
    puts "页数: #{reader.page_count}"

    reader.pages.each_with_index do |page, i|
      puts "=== 第 #{i+1} 页 ==="
      puts page.text
      #puts page.raw_content
    end
  end
end
