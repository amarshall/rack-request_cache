require 'rack/request_cache/cache'

describe Rack::RequestCache::Cache do
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
end
