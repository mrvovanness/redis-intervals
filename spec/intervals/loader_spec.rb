require 'spec_helper'

describe Intervals::Loader do
  let(:loader) { Intervals::Loader.new(Redis.new, 'test') }
  let(:redis)  { loader.redis }

  it 'load ranges correctly' do
    prepared_data = {
      1 => ['beeline_ips'],
      8 => ['russia_ips', 'beeline_ips'],
      11 => ['mts_ips', 'russia_ips'],
      16 => ['mts_ips'],
      21 => ['']
    }
    loader.load(prepared_data)
    redis.keys('test:range:*').each do |key|
      key_range_num = key.split(':').last.to_i
      expect(redis.lrange(key, 0, -1)).to eq prepared_data[key_range_num]
    end
  end

  it 'load indexes correctly' do
    prepared_data = {
      1 => ['beeline_ips'],
      8 => ['russia_ips', 'beeline_ips'],
      11 => ['mts_ips', 'russia_ips'],
      16 => ['mts_ips'],
      21 => ['']
    }
    loader.load(prepared_data)
    expect(redis.zrange('test:range_index', 0, -1, with_scores: true)).to eq([
      ["test:range:1", 1.0],
      ["test:range:8", 8.0],
      ["test:range:11", 11.0],
      ["test:range:16", 16.0],
      ["test:range:21", 21.0]
    ])
  end
end
