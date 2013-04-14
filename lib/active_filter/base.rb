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
    include ::Enumerable

    attr_reader :filters

    def initialize(data, scope=nil)
      @data = data
      @scope = scope

      columns = self.model.columns

      # fields で指定した列だけをフィルタ可能にする
      fields = self.class.__send__(:_fields)
      unless fields.empty?
        columns = columns.select { |column|
          fields.include?(column.name) ||
            fields.include?(column.name.to_sym)
        }
      end

      # exclude で指定した列を除外する
      excludes = self.class.__send__(:_exclude)
      unless excludes.empty?
        columns = columns.reject { |column|
          fields.include?(column.name) ||
            fields.include?(column.name.to_sym)
        }
      end

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
  end
end

