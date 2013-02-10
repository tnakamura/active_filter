# coding: utf-8
require "active_support"

module ActiveFilter
  class Filter
    attr_reader :name

    def initialize(name)
      @name = name.to_s
    end

    def convert_value(value)
      value
    end

    def lookup_type
      "exact"
    end

    def filter(scope, value, lookup_type)
      case lookup_type
      when "exact"
        return scope.where("#{@name} = ?", value)
      when "contains"
        return scope.where("#{@name} LIKE ?", "%#{value}%")
      when "gt"
        return scope.where("#{@name} > ?", value)
      when "lt"
        return scope.where("#{@name} < ?", value)
      when "gte"
        return scope.where("#{@name} >= ?", value)
      when "lte"
        return scope.where("#{@name} <= ?", value)
      else
        raise ArgumentError.new("#{lookup_type} is not supported.")
      end
    end
  end

  class StringFilter < Filter
    def lookup_type
      ["exact", "contains"]
    end
  end

  class TextFilter < StringFilter;end

  class IntegerFilter < Filter
    def lookup_type
      ["exact", "gt", "lt", "gte", "lte"]
    end

    def convert_value(value)
      value.to_i
    end
  end

  class FloatFilter < IntegerFilter
    def convert_value(value)
      value.to_f
    end
  end

  class DecimalFilter < IntegerFilter;end

  class DateTimeFilter < Filter
    def lookup_type
      ["exact", "gt", "lt", "gte", "lte"]
    end

    def convert_value(value)
      value.to_datetime
    end
  end

  class DateFilter < DateTimeFilter
    def convert_value(value)
      value.to_date
    end
  end

  class TimeFilter < DateTimeFilter
    def convert_value(value)
      value.to_time
    end
  end

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

