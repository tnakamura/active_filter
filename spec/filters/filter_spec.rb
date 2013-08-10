# coding: utf-8
require File.expand_path("../../spec_helper", __FILE__)

describe "Filter" do
  describe "#initialize" do
    it "name を指定してインスタンスを生成できるべき" do
      @filter = ActiveFilter::Filter.new("foo")
      @filter.should_not be_nil
    end
  end

  describe "#name" do
    it "initialize で渡した名前を取得できるべき" do
      @filter = ActiveFilter::Filter.new("foo")
      @filter.name.should eq("foo")
    end
  end

  describe "#filter" do
    before do
      FactoryGirl.create(:task, {
        :name => "foo",
      })
    end

    it "name 属性を value で絞り込むスコープを返すべき" do
      @filter = ActiveFilter::Filter.new("name")
      @scope = @filter.filter(Task, "foo", "exact")
      @scope.count.should eq(1)
    end

    it "startswith を指定すると先頭一致のスコープを返すべき" do
      @filter = ActiveFilter::Filter.new("name")
      @scope = @filter.filter(Task, "fo", "startswith")
      @scope.count.should eq(1)
    end

    it "endswith を指定すると後方一致のスコープを返すべき" do
      @filter = ActiveFilter::Filter.new("name")
      @scope = @filter.filter(Task, "oo", "endswith")
      @scope.count.should eq(1)
    end

    it "lookup_type にサポートしていない値を指定すると ArgumentError を発生するべき" do
      proc {
        @filter = ActiveFilter::Filter.new("name")
        @scope = @filter.filter(Task, "foo", "hogehoge")
      }.should raise_error(ArgumentError)
    end
  end
end

