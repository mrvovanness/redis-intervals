require "redis"

module Intervals
  class Base
    attr_reader :redis

    def initialize(redis = Redis.new)
      @redis = redis
    end

    # You load intervals by specifying it along with some
    # name for it
    # i = Intervals::Base.new(Redis.new)
    # i.load(beeline_ips: [1, 10], mts_ips: [11, 20], russia_ips: [8, 15])
    def load(data={})
      result = {}

      data.each do |range_name, range_limits|
        lower_bound = range_limits.first
        upper_bound = range_limits.last

        if result[lower_bound]
          result[lower_bound].push(range_name)
        else
          result[lower_bound] = [range_name]
          start_key_new = true
        end


        #result[upper_bound + 1] ? nil : result[upper_bound + 1] = []
        sorted_keys = result.keys.sort #=> [1,4,6]
        sorted_keys.each_with_index do |key, index|
          @last_key = key
          prev_key = sorted_keys[index - 1]
          if key == lower_bound && start_key_new && key > prev_key
            result[lower_bound] |= result[prev_key]
          else
            if key <= upper_bound && key > lower_bound
              result[key].push(range_name)
            end
            if key > upper_bound
              @last_key = prev_key
              break
            end
          end
        end

        if result[upper_bound + 1].nil?
          result[upper_bound + 1] = result[@last_key] - [range_name]
        end
      end
      result
    end

    private
    def x
        result[lower_bound].push(range_name)
        result[upper_bound + 1].empty? ? result[upper_bound + 1] = [] : nil

        sorted_keys = result.keys.sort
        keys_to_update = sorted_keys.each_with_index.reduce([]) do |acc, (n, i)|
        end

        keys_to_update.each do |key, index|
          previous_element = result[keys_to_update[index - 1]]
          result[key] |= result[previous_element]
        end
    end
  end
end
