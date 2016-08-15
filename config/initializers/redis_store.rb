uri = ENV["REDISTOGO_URL"] || "redis://localhost:6379/"
# REDIS = Redis.new(:url => uri)
UltimetaApiWrapRails::Application.config.cache_store = :redis_store, uri
UltimetaApiWrapRails::Application.config.session_store :redis_store, redis_server: uri
