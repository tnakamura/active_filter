# coding: utf-8
require File.expand_path("../../spec_helper", __FILE__)
require "date"

describe "DateField" do
  before do
    @field = ActiveFilter::DateField.new("date")
  end

  describe "lookup_type" do
    subject { @field.lookup_type }
    it { should eq(["exact", "gt", "lt"]) }
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

