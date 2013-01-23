# coding: utf-8
require "active_filter/field"

module ActiveFilter
  class Base
    include ::Enumerable

    attr_reader :fields

    def initialize(data, scope=nil)
      @data = data
      @scope = scope

      @fields = []
      self.class._model.columns.each do |column|
        if self.class._field_names.include?(column.name) ||
          self.class._field_names.include?(column.name.to_sym)
          @fields << _create_field_from_column(column)
        end
      end
    end

    def self._field_names #:nodoc:
      @field_names ||= []
    end

    def self._model #:nodoc:
      @model
    end

    def self._orders #:nodoc:
      @orders ||= []
    end

    def _create_field_from_column(column)
      case column.type
      when :primary_key
        return Field.new(column.name)
      when :string
        return StringField.new(column.name)
      when :text
        return TextField.new(column.name)
      when :integer
        return IntegerField.new(column.name)
      when :float
        return FloatField.new(column.name)
      when :decimal
        return DecimalField.new(column.name)
      when :datetime
        return DateTimeField.new(column.name)
      when :timestamp
        return Field.new(column.name)
      when :time
        return TimeField.new(column.name)
      when :date
        return DateField.new(column.name)
      when :binary
        return Field.new(column.name)
      when :boolean
        return BooleanField.new(column.name)
      else
        raise ArgumentError.new("#{column.type} is not supported.")
      end
    end
    private :_create_field_from_column

    # コンストラクタで受け取ったスコープまたは
    # model.scoped を返す
    def _scoped
      if @scope.nil?
        self.class._model.scoped
      else
        @scope
      end
    end
    private :_scoped

    # フィルタを作成する対象のモデルを指定します。
    def self.model(klass)
      # Class クラスのインスタンスである ActiveFilter::Base オブジェクトの
      # インスタンス変数にモデルの型を格納
      unless klass.ancestors.include?(ActiveRecord::Base)
        raise ArgumentError.new("klass required inherit ActiveRecord::Base")
      end
      @model = klass
    end

    def self.fields(*names)
      # Class クラスのインスタンスである ActiveFilter::Base オブジェクトの
      # インスタンス変数にフィールド名を格納
      @field_names = names
    end

    def self.order(*names)
      @orders = names
    end

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

    def _lookups_from_field(field)
      lookups = { field.name => "exact" }

      lookup_types = [field.lookup_type].flatten
      lookup_types.each do |lookup_type|
        lookup = "#{field.name}__#{lookup_type}"
        lookups[lookup] = lookup_type
      end

      lookups
    end
    private :_lookups_from_field

    def to_scope
      scope = _scoped
      matched = false

      @fields.each do |field|
        lookups = _lookups_from_field(field)
        lookups.each do |lookup, lookup_type|
          if @data.include?(lookup)
            converted_value = field.convert_value(@data[lookup])
            scope = field.filter(scope, converted_value, lookup_type)
            matched = true
          elsif @data.include?(lookup.to_sym)
            converted_value = field.convert_value(@data[lookup.to_sym])
            scope = field.filter(scope, converted_value, lookup_type)
            matched = true
          end
        end
      end

      # ユーザーの入力がフィルタにかからなかった場合は
      # 該当無しにする
      unless matched
        scope = scope.where("1 = 2")
      end

      self.class._orders.each do |order|
        scope = scope.order(order.to_s)
      end

      scope
    end
  end
end

