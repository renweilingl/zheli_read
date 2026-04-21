# 种子数据

# 创建默认超级管理员
if User.where(email: 'admin@zheli.com').empty?
  admin = User.create!(
    name: '超级管理员',
    email: 'admin@zheli.com',
    password: 'admin123456',
#    password_confirmation: 'admin123456',
    role: 'super_admin'
  )
  puts "✅ 创建超级管理员: #{admin.email}"
end

# 创建测试编辑
if User.where(email: 'editor@zheli.com').empty?
  editor = User.create!(
    name: '测试编辑',
    email: 'editor@zheli.com',
    password: 'editor123456',
#    password_confirmation: 'editor123456',
    role: 'editor'
  )
  puts "✅ 创建测试编辑: #{editor.email}"
end

# 创建测试运营
if User.where(email: 'operator@zheli.com').empty?
  operator = User.create!(
    name: '测试运营',
    email: 'operator@zheli.com',
    password: 'operator123456',
#    password_confirmation: 'operator123456',
    role: 'operator'
  )
  puts "✅ 创建测试运营: #{operator.email}"
end

# 创建测试财务
if User.where(email: 'finance@zheli.com').empty?
  finance = User.create!(
    name: '测试财务',
    email: 'finance@zheli.com',
    password: 'finance123456',
#    password_confirmation: 'finance123456',
    role: 'finance'
  )
  puts "✅ 创建测试财务: #{finance.email}"
end

puts "\n🎉 种子数据创建完成！"
puts "\n默认账号信息："
puts "超级管理员: admin@zheli.com / admin123456"
puts "测试编辑: editor@zheli.com / editor123456"
puts "测试运营: operator@zheli.com / operator123456"
puts "测试财务: finance@zheli.com / finance123456"

[{group_name: "学龄前", name: "4-6岁"},
 {group_name: "小学", name: "一年级"},
 {group_name: "小学", name: "二年级"},
 {group_name: "小学", name: "三年级"},
 {group_name: "小学", name: "四年级"},
 {group_name: "小学", name: "五年级"},
 {group_name: "小学", name: "六年级"},
 {group_name: "初中", name: "初一"},
 {group_name: "初中", name: "初二"},
 {group_name: "初中", name: "初三"},
 {group_name: "高中", name: "高中"},
].each do |x|
  if Grade.where(name: x[:name]).empty?
    Grade.create(group_name: x[:group_name], name: x[:name])
  end
end

["有声", "视频", "图书", "绘本"].each do |name|
  if Category.where(name: name).empty?
    Category.create(name: name, active: true)
  end
end
