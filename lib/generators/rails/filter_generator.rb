# coding: utf-8
module Rails
  module Generators
    class FilterGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path("../templates", __FILE__)

      argument :attributes, :type => :array, :default => [], :banner => "field field"

      def create_filter_file
        template "filter.rb", "app/filters/#{file_name}_filter.rb"
      end
    end
  end
end

