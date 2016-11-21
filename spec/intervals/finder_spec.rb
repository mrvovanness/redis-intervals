require 'spec_helper'

describe Intervals::Finder do
  let(:finder) { Intervals::Finder.new(Redis.new, 'test') }
  let(:loader) { Intervals::Loader.new(Redis.new, 'test') }
  let(:redis)  { loader.redis }

  before do
    prepared_data = {
      1 => ['beeline_ips'],
      8 => ['russia_ips', 'beeline_ips'],
      11 => ['mts_ips', 'russia_ips'],
      16 => ['mts_ips'],
      21 => ['']
    }
    loader.load(prepared_data)
  end

  it 'finds beeline only ip ' do
    result = finder.find(1)
    expect(result).to eq ['beeline_ips']
  end

  it 'finds beeline and russia ip' do
    result = finder.find(10)
    expect(result).to eq ['russia_ips', 'beeline_ips']
  end

  it 'finds mts and russia ip' do
    result = finder.find(11)
    expect(result).to eq ['mts_ips', 'russia_ips']
  end

  it 'finds mts only ip' do
    result = finder.find(17)
    expect(result).to eq ['mts_ips']
  end

  it 'finds empty range for ip' do
    result = finder.find(21)
    expect(result).to eq ['']
  end

  it 'finds empty range for ip(0)' do
    result = finder.find(0)
    expect(result).to eq []
  end
end
