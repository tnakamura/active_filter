# ActiveFilter

ActiveFilter is a Rails engine for allowing users to filter scope dynamically.

## Installation

Add this line to your application's Gemfile:

    gem 'active_filter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_filter 

## Usage

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

