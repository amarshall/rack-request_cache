require 'rack/request_cache/version'
require 'rack/request_cache/cache'

module Rack
  class RequestCache
    def initialize app
      @app = app
    end

    def call env
      @app.call env
    ensure
      self.class.cache_store.clear!
    end

    def self.cache_store
      @cache_store ||= Cache.new
    end

    def self.cache *args, &block; cache_store.cache(*args, &block); end
    def self.fetch *args; cache_store.fetch(*args); end
    def self.has_key? *args; cache_store.has_key?(*args); end
  end
end
