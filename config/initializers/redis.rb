uri = URI.parse(ENV["REDISTOGO_URL"] || "redis://localhost:6379/" )
REDIS = Redis.new(:url => uri, :host => uri.host, :port => uri.port, :password => uri.password)
