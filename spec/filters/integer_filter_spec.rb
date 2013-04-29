# coding: utf-8
require File.expand_path("../../spec_helper", __FILE__)

describe "IntegerFilter" do
  before do
    @filter = ActiveFilter::IntegerFilter.new("foo")
  end

  describe "lookup_type" do
    subject { @filter.lookup_type }
    it { should include("exact") }
    it { should include("gt") }
    it { should include("lt") }
    it { should include("gte") }
    it { should include("lte") }
  end

  describe "convert_value" do
    context "value が 100 のとき" do
      subject { @filter.convert_value(100) }
      it { should eq(100) }
    end

    context "value が '100' のとき" do
      subject { @filter.convert_value('100') }
      it { should eq(100) }
    end
  end
end

