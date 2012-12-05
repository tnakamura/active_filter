#coding: utf-8
module ActiveFilter #:nodoc:
  class Engine < ::Rails::Engine #:nodoc:
    config.generators do |g|
      g.test_framework :rspec, :view_specs => false
    end
  end
end
