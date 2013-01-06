# coding: utf-8
require File.expand_path("../../spec_helper", __FILE__)
require "date"

describe "TimeField" do
  before do
    @field = ActiveFilter::TimeField.new("date")
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
    context "value が Time.utc(2013, 1, 1, 12, 10, 1) のとき" do
      subject { @field.convert_value(Time.utc(2013, 1, 1, 12, 10, 1)) }
      it { should eq(Time.utc(2013, 1, 1, 12, 10, 1)) }
      it { should be_a_kind_of(Time) }
    end

    context "value が '2013-1-1 12:10:01' のとき" do
      subject { @field.convert_value('2013-1-1 12:10:01') }
      it { should eq(Time.utc(2013, 1, 1, 12, 10, 1)) }
      it { should be_a_kind_of(Time) }
    end
  end
end

