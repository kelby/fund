Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:7372/12' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:7372/12' }
end
