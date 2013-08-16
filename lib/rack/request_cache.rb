require 'rack/request_cache/version'
require 'rack/request_cache/cache'
require 'thread_variable'

module Rack
  class RequestCache
    extend ThreadVariable
    thread_variable :cache_store

    def initialize app
      @app = app
    end

    def call env
      self.class.cache_store ||= Cache.new
      @app.call env
    ensure
      self.class.clear!
    end

    def self.cache *args, &block; cache_store.cache(*args, &block); end
    def self.clear!; cache_store.clear!; end
    def self.fetch *args; cache_store.fetch(*args); end
    def self.has_key? *args; cache_store.has_key?(*args); end
  end
end
