# coding: utf-8
require "active_filter/filter"

module ActiveFilter
  class IntegerFilter < Filter
    def lookup_type
      ["exact", "gt", "lt", "gte", "lte"]
    end

    def convert_value(value)
      value.to_i
    end
  end
end

