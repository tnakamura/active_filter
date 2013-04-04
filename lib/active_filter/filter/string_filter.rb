# coding: utf-8
require "active_filter/filter"

module ActiveFilter
  class StringFilter < Filter
    def lookup_type
      ["exact", "contains"]
    end
  end
end

