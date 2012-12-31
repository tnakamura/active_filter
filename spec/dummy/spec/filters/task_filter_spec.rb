# coding: utf-8
require File.expand_path('../../spec_helper', __FILE__)

describe TaskFilter do
  describe "#to_scope" do
    context "data に name が含まれているとき" do
      before do
        FactoryGirl.create(:task, :name => "foo")
        FactoryGirl.create(:task, :name => "bar")
        @filter = TaskFilter.new(:name => "foo")
      end

      it "name が foo のタスクだけを取得できる" do
        @scope = @filter.to_scope
        @scope.count.should eq(1)
      end
    end

    context "data に name_extract が含まれているとき" do
      before do
        FactoryGirl.create(:task, :name => "foo")
        FactoryGirl.create(:task, :name => "bar")
        @filter = TaskFilter.new(:name__extract => "foo")
      end

      it "name が foo のタスクだけを取得できる" do
        @scope = @filter.to_scope
        @scope.count.should eq(1)
      end
    end
  end
end
