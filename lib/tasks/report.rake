namespace :reports do
  def extract_pdf_text(pdf_path)
    reader = PDF::Reader.new(pdf_path)
    full_text = ""

    reader.pages.each do |page|
      text = page.text

      if text.strip.empty?
        puts "⚠️ 页面 #{page.number} 无文本，检查原始内容..."

        # 检查是否有文本操作符
        if page.raw_content =~ /Tj|TJ|'|"/
          puts "   → 发现文本操作符，但提取失败（可能是字体问题）"
          # 可以尝试备用方法或记录页面编号
        else
          puts "   → 没有文本操作符，此页为图片型 PDF"
        end
      else
        full_text << text << "\n"
      end
    end
    full_text
  end

  desc "任务测试"
  task :job_test => :environment do
    #text = extract_pdf_text("1.pdf")
    #puts text if text.length > 0
    reader = PDF::Reader.new("1.pdf")
    puts reader.info
    #puts "PDF 版本: #{reader.pdf_version}"
    #puts "页数: #{reader.page_count}"

    reader.pages.each_with_index do |page, i|
      puts "=== 第 #{i+1} 页 ==="
    #  puts page.text
      puts page.raw_content
    end
  end
end
