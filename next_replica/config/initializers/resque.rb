require "resque"
require "resque/scheduler"

Resque.redis = Redis.new(url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0"))
Resque.schedule = {} unless Resque.respond_to?(:schedule)
Resque::Scheduler.dynamic = true
