# frozen_string_literal: true

YAML::load_file(File.join(__dir__, '../yetting.yml'))

sidekiq_config = { url: "redis://#{Yetting.redis['password']}@#{Yetting.redis['url']}:6379/0" }

Sidekiq.configure_server do |config|
  config.redis = { :url => "redis://#{Yetting.redis['url']}:6379/0", password: Yetting.redis['password'] }
end

Sidekiq.configure_client do |config|
  config.redis = { :url => "redis://#{Yetting.redis['url']}:6379/0", password: Yetting.redis['password'] }
end
