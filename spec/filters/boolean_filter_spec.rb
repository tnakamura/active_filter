# coding: utf-8
require File.expand_path("../../spec_helper", __FILE__)

describe "BooleanFilter" do
  describe "convert_value" do
    before do
      @field = ActiveFilter::BooleanFilter.new("foo")
    end

    context "value が nil のとき" do
      subject { @field.convert_value(nil) }
      it { should be_false }
    end

    context "value が false のとき" do
      subject { @field.convert_value(false) }
      it { should be_false }
    end

    context "value が 0 のとき" do
      subject { @field.convert_value(0) }
      it { should be_false }
    end

    context "value が 'no' のとき" do
      subject { @field.convert_value('no') }
      it { should be_false }
    end

    context "value が 'false' のとき" do
      subject { @field.convert_value('false') }
      it { should be_false }
    end

    context "value が '0' のとき" do
      subject { @field.convert_value('0') }
      it { should be_false }
    end

    context "value が 1 のとき" do
      subject { @field.convert_value(1) }
      it { should be_true }
    end

    context "value が true のとき" do
      subject { @field.convert_value(true) }
      it { should be_true }
    end

    context "value が 'true' のとき" do
      subject { @field.convert_value('true') }
      it { should be_true }
    end

    context "value が 'yes' のとき" do
      subject { @field.convert_value('yes') }
      it { should be_true }
    end

    context "value が '1' のとき" do
      subject { @field.convert_value('1') }
      it { should be_true }
    end
  end
end

