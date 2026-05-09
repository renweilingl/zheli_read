# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{ENV["REDIS_URL"]}:6379/0", password: ENV["REDIS_PASSWORD"] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{ENV["REDIS_URL"]}:6379/0", password: ENV["REDIS_PASSWORD"] }
end
