require 'spec_helper'

describe Intervals::Base do
  let(:i) { Intervals::Base.new }

  context 'load data in redis' do
    before do
    end

    it 'hello world' do
      result = i.load(beeline_ips: [1, 10], mts_ips: [11, 20], russia_ips: [8, 15])
      expect(result).to eq({
        1 => [:beeline_ips],
        8 => [:russia_ips, :beeline_ips],
        11 => [:mts_ips, :russia_ips],
        16 => [:mts_ips],
        21 => []
      })
    end

    it '2 ranges have intersection' do
      result = i.load(beeline: [1, 10], mts: [5, 15])
      expect(result).to eq({
        1 => [:beeline],
        5 => [:mts, :beeline],
        11 => [:mts],
        16 => []
      })
    end

    it '2 ranges have near bounds' do
      result = i.load(beeline: [1, 10], mts: [11, 15])
      expect(result).to eq({
        1 => [:beeline],
        11 => [:mts],
        16 => []
      })
    end

    it '2 ranges have no intersection' do
      result = i.load(beeline: [1, 10], mts: [20, 40])
      expect(result).to eq({
        1 => [:beeline],
        11 => [],
        20 => [:mts],
        41 => []
      })
    end

    it '2 ranges are identical' do
      result = i.load(beeline: [1, 10], mts: [1, 10])
      expect(result).to eq({
        1 => [:beeline, :mts],
        11 => []
      })
    end

    it 'one range is a subset of another one' do
      result = i.load(beeline: [1, 10], mts: [4, 8])
      expect(result).to eq({
        1 => [:beeline],
        4 => [:mts, :beeline],
        9 => [:beeline],
        11 => []
      })
    end

    it 'one range only' do
      result = i.load(beeline: [1, 10])
      expect(result).to eq({
        1 => [:beeline],
        11 => []
      })
    end

    it '2 ranges with the same name' do
      result = i.load(beeline: [1, 10], beeline: [20, 30])
      expect(result).to eq({
      })
    end
  end
end
