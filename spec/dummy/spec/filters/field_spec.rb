# coding: utf-8
require File.expand_path("../../spec_helper", __FILE__)

describe "Field" do
  describe "#initialize" do
    it "name を指定してインスタンスを生成できるべき" do
      @field = ActiveFilter::Field.new("foo")
      @field.should_not be_nil
    end
  end

  describe "#name" do
    it "initialize で渡した名前を取得できるべき" do
      @field = ActiveFilter::Field.new("foo")
      @field.name.should eq("foo")
    end
  end

  describe "#filter" do
    before do
      FactoryGirl.create(:task, {
        :name => "foo",
      })
    end

    it "name 属性を value で絞り込むスコープを返すべき" do
      @field = ActiveFilter::Field.new("name")
      @scope = @field.filter(Task, "foo", "extract")
      @scope.count.should eq(1)
    end
    
    it "extract にサポートしていない値を指定すると ArgumentError を発生するべき" do
      proc {
        @field = ActiveFilter::Field.new("name")
        @scope = @field.filter(Task, "foo", "hogehoge")
      }.should raise_error(ArgumentError)
    end
  end
end

