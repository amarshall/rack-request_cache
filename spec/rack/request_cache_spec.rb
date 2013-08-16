require 'rack/request_cache'

require 'rack/builder'
require 'rack/lint'
require 'rack/mock'
require 'rack/response'

describe Rack::RequestCache do
  def join_body body_obj
    body = ''
    body_obj.each { |s| body << s }
    body
  end

  it "is a Rack middleware" do
    app = Rack::Builder.app do
      use Rack::Lint
      use Rack::RequestCache
      run ->(env) { [418, { 'A-Header' => 'Stuff' }, ['the body']] }
    end

    request = Rack::MockRequest.env_for '/'
    status, headers, body_obj = app.call request
    body = join_body(body_obj)

    expect(status).to eq 418
    expect(headers).to eq ({ 'A-Header' => 'Stuff' })
    expect(body).to eq 'the body'
  end

  it "clears the cache after the request ends" do
    app = ->(env) do
      Rack::RequestCache.cache(:foo) { 'bar' }
      expect(Rack::RequestCache.fetch(:foo)).to eq 'bar'
    end

    request_cache = Rack::RequestCache.new app
    request_cache.call({})

    expect(Rack::RequestCache.has_key?(:foo)).to eq false
  end

  it "clears the cache when the request raises an error, reraising it" do
    exception_class = Class.new Exception
    app = ->(env) do
      Rack::RequestCache.cache(:foo) { 'bar' }
      expect(Rack::RequestCache.fetch(:foo)).to eq 'bar'
      raise exception_class
    end

    request_cache = Rack::RequestCache.new app
    expect { request_cache.call({}) }.to raise_error exception_class

    expect(Rack::RequestCache.has_key?(:foo)).to eq false
  end
end
