# coding: utf-8

module ActiveFilter
  class Field
    attr_reader :name

    def initialize(name)
      @name = name.to_s
    end

    def convert_value(value)
      value
    end

    def lookup_type
      "extract"
    end

    def filter(scope, value, lookup_type)
      case lookup_type
      when "extract"
        return scope.where("#{@name} = ?", value)
      when "gt"
        return scope.where("#{@name} > ?", value)
      when "lt"
        return scope.where("#{@name} < ?", value)
      else
        raise ArgumentError.new("#{lookup_type} is not supported.")
      end
    end
  end

  class StringField < Field;end
  class TextField < Field;end

  class IntegerField < Field
    def lookup_type
      ["extract", "gt", "lt"]
    end

    def convert_value(value)
      value.to_i
    end
  end

  class FloatField < IntegerField
    def convert_value(value)
      value.to_f
    end
  end

  class DecimalField < IntegerField;end

  class BooleanField < Field
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

