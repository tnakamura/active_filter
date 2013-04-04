# coding: utf-8
require "active_filter/filter/integer_filter"

module ActiveFilter
  class FloatFilter < IntegerFilter
    def convert_value(value)
      value.to_f
    end
  end
end

