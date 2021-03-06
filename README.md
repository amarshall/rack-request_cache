# Rack::RequestCache

[![Build Status](https://secure.travis-ci.org/amarshall/rack-request_cache.png?branch=master)](https://travis-ci.org/amarshall/rack-request_cache)
[![Code Climate rating](https://codeclimate.com/github/amarshall/rack-request_cache.png)](https://codeclimate.com/github/amarshall/rack-request_cache)
[![Gem Version](https://badge.fury.io/rb/rack-request_cache.png)](https://rubygems.org/gems/rack-request_cache)

Provides a caching layer that exists only within a single Rack request. The middleware itself is thread-safe; each thread has its own cache.

## Installation

Install as usual: `gem install rack-request_cache` or add `gem 'rack-request_cache'` to your Gemfile.

## Usage

Add the middleware to your app (likely in your `config.ru`):

```ruby
require 'rack/request_cache'

use Rack::RequestCache
run MyApp
```

Then, whenever you wish to cache something:

```ruby
Rack::RequestCache.cache do
  expensive_operation
end
```

## Contributing

Contributions are welcome. Please be sure that your pull requests are atomic so they can be considered and accepted separately.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits & License

Copyright © 2013 J. Andrew Marshall. License is available in the LICENSE file.
