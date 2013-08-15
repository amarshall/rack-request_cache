require 'rack/request_cache/cache'

describe Rack::RequestCache::Cache do
  describe "#cache" do
    it "returns the result of the block" do
      test_object = double
      result = double
      expect(test_object).to receive(:expensive_operation).once
                             .and_return(result)

      cache = Rack::RequestCache::Cache.new
      returned = cache.cache(:key) { test_object.expensive_operation }

      expect(returned).to eq result
    end

    it "caches the return value of the block" do
      test_object = double
      result = double
      expect(test_object).to receive(:expensive_operation).once
                             .and_return(result)

      cache = Rack::RequestCache::Cache.new
      returned_1 = cache.cache(:key) { test_object.expensive_operation }
      returned_2 = cache.cache(:key) { test_object.expensive_operation }

      expect(returned_1).to eq result
      expect(returned_2).to eq result
    end
  end
end
