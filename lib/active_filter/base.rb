# coding: utf-8
require "active_filter/field"

module ActiveFilter
  class Base
    attr_reader :fields

    def initialize(data={})
      @data = data 
      @fields = self.class._field_names.map { |name|
        Field.new(name)
      }
    end

    private
    def self._field_names
      # Class クラスのインスタンスである ActiveFilter::Base オブジェクトの
      # インスタンス変数にフィールド名を格納
      @field_names ||= []
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

    def self.fields(*names)
      @field_names = names
    end

    public
    def model
      self.class._model
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
      scope = self.class._model.scoped
      
      @fields.each do |field|
        name = field.name
        if @data.include?(name)
          scope = field.filter(scope, @data[name])
        elsif @data.include?(name.to_sym)
          scope = field.filter(scope, @data[name.to_sym])
        end
      end

      scope
    end
  end
end

