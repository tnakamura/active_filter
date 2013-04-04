# coding: utf-8
require "active_support"
require "active_filter/filter/date_time_filter"

module ActiveFilter
  class TimeFilter < DateTimeFilter
    def convert_value(value)
      value.to_time
    end
  end
end

