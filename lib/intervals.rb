require 'redis'
require 'intervals/helper'
require 'intervals/loader'
require 'intervals/finder'

module Intervals
  # This class has #load and #search methods
  class Base
    attr_reader :loader, :finder

    def initialize(redis = Redis.new, prefix = nil)
      @loader = Loader.new(redis, prefix)
      @finder = Finder.new(redis, prefix)
    end

    # You load intervals by specifying it along with some
    # name for it
    # i = Intervals::Base.new(Redis.new)
    # i.load([ {beeline_ips: [1, 10], {mts_ips: [11, 20] ])
    def load(data = {})
      result = calculate(data)
      loader.load(result)
    end

    def find(number)
      finder.find(number)
    end

    def calculate(data)
      data.each_with_object({}) do |range_data, result|
        @lower_bound = range_data.values.first.first
        @upper_bound = range_data.values.first.last
        @range_name  = range_data.keys.first

        setup_key_for_lower_bound(result)
        last_key = copy_range_name_to_keys(result)
        setup_key_for_upper_bound(result, last_key)
      end
    end

    private

    def setup_key_for_lower_bound(result)
      if result[@lower_bound]
        result[@lower_bound].push(@range_name)
        @lower_bound_key_new = false
      else
        result[@lower_bound] = [@range_name]
        @lower_bound_key_new = true
      end
    end

    def copy_range_name_to_keys(result)
      sorted_keys = result.keys.sort #=> [1,4,6]
      last_key    = nil

      sorted_keys.each_with_index do |key, index|
        next if key < @lower_bound
        last_key = key
        prev_key = sorted_keys[index - 1]

        if key == @lower_bound && @lower_bound_key_new && key > prev_key
          result[@lower_bound] |= result[prev_key]
        elsif key <= @upper_bound && key > @lower_bound
          result[key].push(@range_name)
        elsif key > @upper_bound
          last_key = prev_key
          break
        end
      end
      last_key
    end

    def setup_key_for_upper_bound(result, last_key)
      if result[@upper_bound + 1].nil?
        result[@upper_bound + 1] = result[last_key] - [@range_name]
      end
    end
  end
end
