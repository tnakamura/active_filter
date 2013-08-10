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
      when "startswith"
        return scope.where("#{@name} LIKE ?", "#{value}%")
      when "endswith"
        return scope.where("#{@name} LIKE ?", "%#{value}")
      else
        raise ArgumentError.new("#{lookup_type} is not supported.")
      end
    end
  end
end

