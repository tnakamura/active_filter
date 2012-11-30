# coding: utf-8
module ActiveFilter
  module Generators
    class FilterGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path("../templates", __FILE__)

      def create_filter_file
        copy_file "filter.rb.erb", "app/filters/#{file_name}_filter.rb"
      end
    end
  end
end

