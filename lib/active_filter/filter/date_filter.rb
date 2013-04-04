# coding: utf-8
require "active_support"
require "active_filter/filter/date_time_filter"

module ActiveFilter
  class DateFilter < DateTimeFilter
    def convert_value(value)
      value.to_date
    end
  end
end

