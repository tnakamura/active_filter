# coding: utf-8
require File.expand_path("../../spec_helper", __FILE__)
require "date"

describe "DateFilter" do
  before do
    @field = ActiveFilter::DateFilter.new("date")
  end

  describe "lookup_type" do
    subject { @field.lookup_type }
    it { should include("exact") }
    it { should include("gt") }
    it { should include("lt") }
    it { should include("gte") }
    it { should include("lte") }
  end

  describe "convert_value" do
    context "value が Date.new(2013, 1, 1) のとき" do
      subject { @field.convert_value(Date.new(2013, 1, 1)) }
      it { should eq(Date.new(2013, 1, 1)) }
      it { should be_a_kind_of(Date) }
    end

    context "value が '2013-1-1' のとき" do
      subject { @field.convert_value('2013-1-1') }
      it { should eq(Date.new(2013, 1, 1)) }
      it { should be_a_kind_of(Date) }
    end
  end
end

