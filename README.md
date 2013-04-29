# ActiveFilter [![Build Status](https://travis-ci.org/tnakamura/active_filter.png?branch=master)](https://travis-ci.org/tnakamura/active_filter) [![Code Climate](https://codeclimate.com/github/tnakamura/active_filter.png)](https://codeclimate.com/github/tnakamura/active_filter) [![Dependency Status](https://gemnasium.com/tnakamura/active_filter.png)](https://gemnasium.com/tnakamura/active_filter) [![Coverage Status](https://coveralls.io/repos/tnakamura/active_filter/badge.png?branch=master)](https://coveralls.io/r/tnakamura/active_filter)

ActiveFilter is a Rails engine for allowing users to filter scope dynamically.

## Installation

Add this line to your application's Gemfile:

    gem 'active_filter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_filter 

## Usage

Generate filter:

    $ rails g active_filter:filter Blog title description

```ruby
class BlogFilter < ActiveFilter::Base
  model Blog
  fields :title, :description
end
```

And then in your controller you could do:

```ruby
class BlogsController < ApplicationController
  def index
    @filter = BlogFilter.new(params)
    @blogs = @filter.to_scope
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

