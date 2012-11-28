# coding: utf-8
require_relative "spec_helper"

describe "Rule" do
  describe "#initialize" do
    before do
      @rule = ActiveFilter::Rule.new("^test") { |scope, value| scope }
    end

    it "インスタンスを生成できるべき" do
      @rule.should be_an_instance_of(ActiveFilter::Rule)
    end
  end

  describe "#match?" do
    before do
      @rule = ActiveFilter::Rule.new("^test") { |scope, value| scope }
    end

    context "文字列がパターンにマッチしたとき" do
      it "true を返すべき" do
        @rule.match?("testName").should be_true
      end
    end
    
    context "文字列がパターンにマッチしなかったとき" do
      it "false を返すべき" do
        @rule.match?("fooName").should be_false
      end
    end
  end

  describe "#filter" do
    class DummyScope;end

    it "@block を呼び出すべき" do
      @rule = ActiveFilter::Rule.new("^test") { |scope, value|
        @value = value
        @scope = scope
      }
      @rule.filter(DummyScope.new, "foo")

      @value.should eq("foo")
      @scope.should be_an_instance_of(DummyScope)
    end
  end
end

