# coding: utf-8
require File.expand_path("../../spec_helper", __FILE__)

describe "FloatField" do
  before do
    @field = ActiveFilter::FloatField.new("foo")
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

    context "value が 100.1 のとき" do
      subject { @field.convert_value(100.1) }
      it { should eq(100.1) }
    end

    context "value が '100.1' のとき" do
      subject { @field.convert_value('100.1') }
      it { should eq(100.1) }
    end
  end
end

