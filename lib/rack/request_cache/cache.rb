module Rack
  class RequestCache
    class Cache
      def initialize
        @cache = {}
      end

      def cache key
        @cache[key] ||= yield
      end
    end
  end
end
