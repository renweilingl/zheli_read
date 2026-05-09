namespace :reports do
  desc "任务测试"
  task :job_test => :environment do
    recommends = []
    grade = Grade.find_by_id 1
    grade.recommends.sorted.each do |x|
      recommends << {recommend_id: x.id, name: x.name}
    end
    p recommends.as_json

    unless recommends.blank?
      recommend = Recommend.find recommends[0][:recommend_id]
      content_groups = []
      recommend.content_groups.sorted.each do |content_group|
        contents = []
        content_group.contents.sorted.each do |content|
          contents << {content_type: content.content_type,
                       content_name: content.content_name,
                       display_img_url: content.display_img_url,
                       compilation_id: content.compilation_id,
                       book_id: content.book_id,
                       author_id: content.author_id}
        end
        content_groups << {name: content_group.name, group_type: content_group.group_type, contents: contents}
      end
      recommend_info = {recommend_id: recommend.id, content_groups: content_groups}

      p recommend_info.as_json
    end

  end
end
