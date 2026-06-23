namespace :reports do
  desc "任务测试"
  task :job_test => :environment do
    grade = Grade.find_by_name("三年级")


    grade.recommends.each do |r|
      next if r.name == "推荐"

      Recommend.where(name: r.name).each do |x|
        r.content_groups.each do |c|
          rd = x.content_groups.find_by(name: c.name)
          if rd.nil?
             x.content_groups.create(name: c.name, sn: c.sn, group_type: c.group_type)
          end
        end
      end
    end

  end
end
