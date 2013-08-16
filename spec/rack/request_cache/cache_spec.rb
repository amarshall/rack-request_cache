require 'rack/request_cache/cache'

describe Rack::RequestCache::Cache do
  it "can store multiple keys" do
    cache = Rack::RequestCache::Cache.new

    cache.cache(:foo) { :bar }
    cache.cache(:baz) { :qux }

    expect(cache.fetch(:foo)).to eq :bar
    expect(cache.fetch(:baz)).to eq :qux
  end

  it "does not allow mutating the cached value" do
    cache = Rack::RequestCache::Cache.new
    value = 'foobar'

    returned = cache.cache(:key) { value }
    expect do
      value << 'baz'
    end.to raise_error RuntimeError, /frozen/
    expect do
      returned << 'baz'
    end.to raise_error RuntimeError, /frozen/

    expect(cache.fetch(:key)).to eq 'foobar'
  end

  describe "#cache" do
    it "returns the result of the block" do
      test_object = double
      result = double
      cache = Rack::RequestCache::Cache.new

      expect(test_object).to receive(:expensive_operation).once
                             .and_return(result)
      returned = cache.cache(:key) { test_object.expensive_operation }

      expect(returned).to eq result
    end

    it "caches the return value of the block" do
      test_object = double
      result = double
      cache = Rack::RequestCache::Cache.new

      expect(test_object).to receive(:expensive_operation).once
                             .and_return(result)
      returned_1 = cache.cache(:key) { test_object.expensive_operation }
      returned_2 = cache.cache(:key) { test_object.expensive_operation }

      expect(returned_1).to eq result
      expect(returned_2).to eq result
    end

    it "caches falsey values" do
      test_object = double
      result = nil
      cache = Rack::RequestCache::Cache.new

      expect(test_object).to receive(:expensive_operation).once
                             .and_return(result)
      cache.cache(:key) { test_object.expensive_operation }
      cache.cache(:key) { test_object.expensive_operation }
    end

    it "raises an ArgumentError when no block is given" do
      cache = Rack::RequestCache::Cache.new
      expect do
        cache.cache(:key)
      end.to raise_error ArgumentError, 'no block given'
    end
  end

  describe "#clear!" do
    it "removes all keys & values from the cache" do
      cache = Rack::RequestCache::Cache.new

      cache.cache(:foo) {}
      cache.cache(:bar) {}

      cache.clear!

      expect(cache.has_key?(:foo)).to eq false
      expect(cache.has_key?(:bar)).to eq false
    end
  end

  describe "#fetch" do
    it "returns the cached result for the key when one exists" do
      value = double
      cache = Rack::RequestCache::Cache.new

      cache.cache(:key) { value }

      expect(cache.fetch(:key)).to eq value
    end

    it "raises a KeyError when the key does not exist" do
      cache = Rack::RequestCache::Cache.new
      expect{ cache.fetch(:key) }.to raise_error KeyError
    end
  end

  describe "#has_key?" do
    it "returns true when the key has been cached" do
      cache = Rack::RequestCache::Cache.new
      cache.cache(:key) {}
      expect(cache.has_key?(:key)).to eq true
    end

    it "returns false when the key has not been cached" do
      cache = Rack::RequestCache::Cache.new
      expect(cache.has_key?(:key)).to eq false
    end
  end
end
