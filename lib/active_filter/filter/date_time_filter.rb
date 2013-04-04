# coding: utf-8
require "active_support"
require "active_filter/filter"

module ActiveFilter
  class DateTimeFilter < Filter
    def lookup_type
      ["exact", "gt", "lt", "gte", "lte"]
    end

    def convert_value(value)
      value.to_datetime
    end
  end
end

