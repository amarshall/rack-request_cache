module Rack
  class RequestCache
    class Cache
      def initialize
        @cache = {}
      end

      def cache key
        return @cache[key] if @cache.has_key? key
        @cache[key] = yield
      end
    end
  end
end
