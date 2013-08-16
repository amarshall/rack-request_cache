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

  def unfreezable_double *args
    double(*args).tap { |d| d.stub(:freeze).and_return d }
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

  it "is thread safe" do
    q1 = Queue.new
    q2 = Queue.new
    app = ->(env) do
      Rack::RequestCache.cache(:foo) { env }
      env.queue.pop
      expect(Rack::RequestCache.fetch(:foo)).to eq env
      env.queue.pop
    end
    env_1 = unfreezable_double 'one', queue: q1
    env_2 = unfreezable_double 'two', queue: q2

    request_cache = Rack::RequestCache.new app

    thread_1 = Thread.new { request_cache.call env_1 }
    thread_2 = Thread.new { request_cache.call env_2 }

    q1 << nil
    q2 << nil
    q1 << nil
    q2 << nil

    thread_1.join
    thread_2.join
  end
end
