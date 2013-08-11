# coding: utf-8
require "active_filter/filter"
require "active_filter/filter/string_filter"
require "active_filter/filter/text_filter"
require "active_filter/filter/integer_filter"
require "active_filter/filter/float_filter"
require "active_filter/filter/decimal_filter"
require "active_filter/filter/boolean_filter"
require "active_filter/filter/date_time_filter"
require "active_filter/filter/date_filter"
require "active_filter/filter/time_filter"

module ActiveFilter
  class Base
    TYPE_FILTER_MAP = {
      primary_key: Filter,
      string: StringFilter,
      text: TextFilter,
      integer: IntegerFilter,
      float:  FloatFilter,
      decimal:  DecimalFilter,
      datetime: DateTimeFilter,
      timestamp: Filter,
      time: TimeFilter,
      date: DateFilter,
      binary: Filter,
      boolean: BooleanFilter,
    }

    include ::Enumerable

    attr_reader :filters

    def initialize(data, scope=nil)
      @data = data
      @scope = scope
      columns = self.model.columns

      # fields で指定した列だけをフィルタ可能にする
      fields = self.class.__send__(:_fields)
      columns = _select_columns(columns, fields) unless fields.empty?

      # exclude で指定した列を除外する
      excludes = self.class.__send__(:_exclude)
      columns = _reject_columns(columns, excludes) unless excludes.empty?

      @filters = columns.map { |column|
        _create_filter_from_column(column)
      }
    end

    module ClassMethods
      # フィルタを作成する対象のモデルを指定します。
      def model(klass)
        # Class クラスのインスタンスである ActiveFilter::Base オブジェクトの
        # インスタンス変数にモデルの型を格納
        unless klass.ancestors.include?(ActiveRecord::Base)
          raise ArgumentError.new("klass required inherit ActiveRecord::Base")
        end
        @model = klass
      end

      def fields(*names)
        # Class クラスのインスタンスである ActiveFilter::Base オブジェクトの
        # インスタンス変数にフィールド名を格納
        @fields = names
      end

      def exclude(*names)
        @excludes = names
      end

      def order(*names)
        @orders = names
      end

      private
      def _model
        @model
      end

      def _fields
        @fields ||= []
      end

      def _exclude
        @excludes ||= []
      end

      def _orders
        @orders ||= []
      end
    end
    extend ClassMethods

    def model
      self.class.__send__(:_model)
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

      self.class.__send__(:_orders).each do |order|
        scope = scope.order(order.to_s)
      end

      scope
    end

    private

    def _select_columns(columns, fields)
      columns.select { |column|
        fields.include?(column.name) ||
          fields.include?(column.name.to_sym)
      }
    end

    def _reject_columns(columns, fields)
      columns.reject { |column|
        fields.include?(column.name) ||
          fields.include?(column.name.to_sym)
      }
    end

    # コンストラクタで受け取ったスコープまたは
    # model.scoped を返す
    def _scoped
      if @scope.nil?
        if ActiveRecord::VERSION::STRING < '4.0'
          self.model.scoped
        else
          # Rails 4 以上のとき
          self.model.all
        end
      else
        @scope
      end
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

    def _create_filter_from_column(column)
      if TYPE_FILTER_MAP.include?(column.type)
        TYPE_FILTER_MAP[column.type].new(column.name)
      else
        raise ArgumentError.new("#{column.type} is not supported.")
      end
    end
  end
end

