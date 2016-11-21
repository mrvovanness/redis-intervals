module Intervals
  class Loader
    include Helper
    attr_reader :redis, :prefix, :data

    def initialize(redis, prefix)
      @redis  = redis
      @prefix = prefix
    end

    def load(prepared_data)
      @data = prepared_data
      load_ranges
      build_index
    end

    private

    def load_ranges
      data.each do |range_bound, ranges|
        range_key = "#{range_key_prefix}#{range_bound}"
        ranges.empty? ? ranges.push(nil) : nil
        redis.rpush(range_key, ranges)
      end
    end

    def build_index
      keys_to_index = redis.keys("#{range_key_prefix}*").flat_map do |key|
        rank = key.split(':').last
        [rank, key]
      end
      redis.zadd(range_index_key, keys_to_index)
    end

  end
end
