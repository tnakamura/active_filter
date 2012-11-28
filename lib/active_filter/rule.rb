# coding: utf-8

module ActiveFilter
  class Rule
    attr_reader :pattern

    def initialize(pattern, &block)
      @pattern = pattern
      @block = block
    end

    def match?(value)
      @regexp ||= Regexp.new(@pattern)
      matched = (@regexp =~ value.to_s)
      !matched.nil?
    end

    def filter(scope, value)
      @block.call(scope, value)
    end
  end
end

