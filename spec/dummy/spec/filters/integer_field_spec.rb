# coding: utf-8
require File.expand_path("../../spec_helper", __FILE__)

describe "IntegerField" do
  before do
    @field = ActiveFilter::IntegerField.new("foo")
  end

  describe "lookup_type" do
    subject { @field.lookup_type }
    it { should eq(["extract", "gt", "lt"]) }
  end

  describe "convert_value" do
    context "value が 100 のとき" do
      subject { @field.convert_value(100) }
      it { should eq(100) }
    end

    context "value が '100' のとき" do
      subject { @field.convert_value('100') }
      it { should eq(100) }
    end
  end
end

