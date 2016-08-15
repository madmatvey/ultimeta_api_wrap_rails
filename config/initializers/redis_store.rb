redis_url = ENV["REDISTOGO_URL"] || "redis://127.0.0.1:6379/0/myapp"
UltimetaApiWrapRails::Application.config.cache_store = :redis_store, redis_url
UltimetaApiWrapRails::Application.config.session_store :redis_store, redis_server: redis_url
