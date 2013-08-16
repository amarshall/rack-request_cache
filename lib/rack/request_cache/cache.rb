module Rack
  class RequestCache
    class Cache
      def initialize
        @cache = {}
      end

      def cache key
        raise ArgumentError, 'no block given' unless block_given?
        return @cache[key] if @cache.has_key? key
        @cache[key] = yield.freeze
      end

      def fetch key
        @cache.fetch key
      end

      def has_key? key
        @cache.has_key? key
      end
    end
  end
end
