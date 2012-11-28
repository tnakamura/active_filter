# coding: utf-8
require "active_filter/rule"

module ActiveFilter
  class Base
    def initialize(params={})
      @params = params
    end

    private
    def self._rules
      # Class クラスのインスタンスである ActiveFilter::Base オブジェクトの
      # インスタンス変数にルールを格納
      @rules ||= []
    end

    def self._model
      # Class クラスのインスタンスである ActiveFilter::Base オブジェクトの
      # インスタンス変数にモデルの型を格納
      @model
    end

    protected
    def self.model(klass)
      @model = klass
    end

    def self.rule(pattern, lmbda=nil, &block)
      if lmbda.nil?
        if block_given?
          callback = block
        else
          # ラムダ式またはブロックのどちらか必須
          raise ArgumentError, "lambda or block are required!"
        end
      else
        callback = lmbda 
      end

      _rules << ActiveFilter::Rule.new(pattern, &callback)
    end

    def self.field(name)
      self.rule "^#{name}$" do |scope, value|
        scope.where(name => value)
      end
    end

    def self.fields(*names)
      names.each do |name|
        self.field(name)
      end
    end

    public
    def model
      self.class._model
    end

    def rules
      self.class._rules
    end

    def each(&block)
      scope = self.to_scope
      unless block_given?
        return scope.each
      end

      scope.each do |obj|
        block.call(obj)
      end
      self
    end

    def to_scope
      scope = self.model.scoped
      @params.each do |key, value|
        # 最初にマッチしたルールを適用する
        rule = self.rules.find { |r| r.match?(key) }
        if rule
          scope = rule.filter(scope, value)
        end
      end
      scope
    end
  end
end

