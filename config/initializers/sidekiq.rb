# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{ENV["REDIS_URL"]}:6379/0", password: ENV["REDIS_PASSWORD"] }

  # 日志输出到文件
  if Rails.env.production?
    sidekiq_logger = File.open(Rails.root.join("log", "sidekiq.log"), "a")
    config.logger = sidekiq_logger
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{ENV["REDIS_URL"]}:6379/0", password: ENV["REDIS_PASSWORD"] }
end
