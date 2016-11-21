module Intervals
  class Finder
    include Helper
    attr_reader :redis, :prefix, :data

    def initialize(redis, prefix)
      @redis  = redis
      @prefix = prefix
    end

    def find(number)
      key = redis.zrevrangebyscore(range_index_key, number, 0, limit: [0, 1])
      redis.lrange(key, 0, -1)
    end
  end
end
