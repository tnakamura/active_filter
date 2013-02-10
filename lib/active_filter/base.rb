# coding: utf-8
require "active_filter/filter"

module ActiveFilter
  class Base
    include ::Enumerable

    attr_reader :filters

    def initialize(data, scope=nil)
      @data = data
      @scope = scope

      # TODO: リファクタリング
      if self.class._fields.empty?
        # fields を指定していなかったら
        # すべての列をフィルタ可能にする
        @filters = self.class._model.columns.map do |column|
          _create_filter_from_column(column)
        end
      else
        # fields で指定した列だけをフィルタ可能にする
        @filters = []
        self.class._model.columns.each do |column|
          if self.class._fields.include?(column.name) ||
            self.class._fields.include?(column.name.to_sym)
            @filters << _create_filter_from_column(column)
          end
        end
      end
    end

    def self._fields #:nodoc:
      @fields ||= []
    end

    def self._model #:nodoc:
      @model
    end

    def self._orders #:nodoc:
      @orders ||= []
    end

    def _create_filter_from_column(column)
      case column.type
      when :primary_key
        return Filter.new(column.name)
      when :string
        return StringFilter.new(column.name)
      when :text
        return TextFilter.new(column.name)
      when :integer
        return IntegerFilter.new(column.name)
      when :float
        return FloatFilter.new(column.name)
      when :decimal
        return DecimalFilter.new(column.name)
      when :datetime
        return DateTimeFilter.new(column.name)
      when :timestamp
        return Filter.new(column.name)
      when :time
        return TimeFilter.new(column.name)
      when :date
        return DateFilter.new(column.name)
      when :binary
        return Filter.new(column.name)
      when :boolean
        return BooleanFilter.new(column.name)
      else
        raise ArgumentError.new("#{column.type} is not supported.")
      end
    end
    private :_create_filter_from_column

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
      @fields = names
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

    def _lookups_from_filter(filter)
      lookups = { filter.name => "exact" }

      lookup_types = [filter.lookup_type].flatten
      lookup_types.each do |lookup_type|
        lookup = "#{filter.name}__#{lookup_type}"
        lookups[lookup] = lookup_type
      end

      lookups
    end
    private :_lookups_from_filter

    def to_scope
      scope = _scoped
      matched = false

      @filters.each do |filter|
        lookups = _lookups_from_filter(filter)
        lookups.each do |lookup, lookup_type|
          if @data.include?(lookup)
            converted_value = filter.convert_value(@data[lookup])
            scope = filter.filter(scope, converted_value, lookup_type)
            matched = true
          elsif @data.include?(lookup.to_sym)
            converted_value = filter.convert_value(@data[lookup.to_sym])
            scope = filter.filter(scope, converted_value, lookup_type)
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

