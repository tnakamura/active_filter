# coding: utf-8
require "active_filter/filter"

module ActiveFilter
  class BooleanFilter < Filter
    def convert_value(value)
      compare_value = value.is_a?(String) ? value.downcase : value
      case compare_value
      when "no", "false", false, "0", 0
        false
      when "yes", "true", true, "1", 1
        true
      when nil
        false
      else
        !!compare_value
      end
    end
  end
end

