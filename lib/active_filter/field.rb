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
end

