# coding: utf-8
require "active_filter/field"

module ActiveFilter
  class Base
    attr_reader :fields

    def initialize(scope=nil, data={})
      if scope.is_a?(Hash)
        @scope = nil
        @data = scope
      else
        @scope = scope
        @data = data
      end

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

    # コンストラクタで受け取ったスコープまたは
    # model.scoped を返す
    def _scoped
      if @scope.nil?
        self.class._model.scoped
      else
        @scope
      end
    end

    protected
    # フィルタを作成する対象のモデルを指定します。
    def self.model(klass)
      unless klass.ancestors.include?(ActiveRecord::Base)
        raise ArgumentError.new("klass required inherit ActiveRecord::Base")
      end
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
      scope = _scoped

      @fields.each do |field|
        # フィールド名でフィルタする
        name = field.name
        if @data.include?(name)
          converted_value = field.convert_value(@data[name])
          scope = field.filter(scope, converted_value, "extract")
        elsif @data.include?(name.to_sym)
          converted_value = field.convert_value(@data[name.to_sym])
          scope = field.filter(scope, converted_value, "extract")
        end

        # lookup_type でフィルタする
        lookup_types = [field.lookup_type].flatten
        lookup_types.each do |lookup_type|
          lookup = "#{name}__#{lookup_type}"
          if @data.include?(lookup)
            converted_value = field.convert_value(@data[lookup])
            scope = field.filter(scope, converted_value, lookup_type)
          elsif @data.include?(lookup.to_sym)
            converted_value = field.convert_value(@data[lookup.to_sym])
            scope = field.filter(scope, converted_value, lookup_type)
          end
        end
      end

      scope
    end
  end
end

