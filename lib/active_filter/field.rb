# coding: utf-8

module ActiveFilter
  class Field
    attr_reader :name

    def initialize(name)
      @name = name.to_s
    end

    def filter(scope, value)
      scope.where("#{@name} = ?", value)
    end
  end
end

