#  config/initializers/active_job_status.rb
# ActiveJobStatus.store = ActiveSupport::Cache::RedisStore.new
# or if you are using https://github.com/sorentwo/readthis
ActiveJobStatus.store = ActiveSupport::Cache::ReadthisStore.new
