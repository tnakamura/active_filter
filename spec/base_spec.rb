# coding: utf-8
require_relative "spec_helper"

class TestScope
  attr_reader :wheres

  def initialize
    @wheres = []
  end

  def where(params={})
    @wheres << params
    self
  end
end

class TestEntry
  attr_accessor :title, :body

  def self.scoped
    TestScope.new
  end
end

describe "Base" do
  describe "#initialize" do
    class TestFilter1 < ::ActiveFilter::Base;end

    context "params を指定したとき" do
      it "@params に指定した params が格納されているべき" do
        @filter = TestFilter1.new(:foo => "bar")
        
        actual = nil
        @filter.instance_eval { actual = @params[:foo] }
        actual.should eq("bar")
      end
    end

    context "params を指定しないとき" do
      it "@params に空の Hash が格納されているべき" do
        @filter = TestFilter1.new
        
        actual = nil
        @filter.instance_eval { actual = @params }
        actual.should be_empty
      end
    end
  end

  describe ".model" do
    class TestFilter2 < ::ActiveFilter::Base
      model TestEntry
    end

    it "model に指定したクラスが格納されているべき" do
      @filter = TestFilter2.new
      @filter.model.should eq(TestEntry)
    end
  end

  describe ".rule" do
    context "ブロックを指定したとき" do
      class TestFilter3 < ::ActiveFilter::Base
        model TestEntry
        rule "^foo$" do |scope, value| scope end;
        rule "^bar$" do |scope, value| scope end;
      end

      it "#rules にルールが格納されているべき" do
        @filter = TestFilter3.new
        @filter.rules.size.should eq(2)
        @filter.rules[0].pattern.should eq("^foo$")
        @filter.rules[1].pattern.should eq("^bar$")
      end
    end

    context "ラムダ式を指定したとき" do
      class TestFilter4 < ::ActiveFilter::Base
        model TestEntry
        rule "^foo$", lambda { |scope, value| scope }
        rule "^bar$", ->(scope, value){ scope }
      end

      it "#rules にルールが格納されているべき" do
        @filter = TestFilter4.new
        @filter.rules.size.should eq(2)
        @filter.rules[0].pattern.should eq("^foo$")
        @filter.rules[1].pattern.should eq("^bar$")
      end
    end

    context "ラムダ式とブロックを両方指定しなかったとき" do
      it "例外が発生するべき" do
        expect {
          class TestFilter10 < ::ActiveFilter::Base
            model TestEntry
            rule "^foo$"
          end
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".field" do
    class TestFilter5 < ::ActiveFilter::Base
      model TestEntry
      field :title
    end

    it "#rules にルールが格納されているべき" do
      @filter = TestFilter5.new
      @filter.rules.size.should eq(1)
      @filter.rules[0].pattern.should eq("^title$")
    end
  end

  describe ".fields" do
    class TestFilter6 < ::ActiveFilter::Base
      model TestEntry
      fields :title, :body
    end

    it "#rules にルールが格納されているべき" do
      @filter = TestFilter6.new
      @filter.rules.size.should eq(2)
      @filter.rules[0].pattern.should eq("^title$")
      @filter.rules[1].pattern.should eq("^body$")
    end
  end

  describe "#to_scope" do
    context "マッチするフィルタが１つだけのとき" do
      class TestFilter7 < ::ActiveFilter::Base
        model TestEntry
        fields :title, :body
      end

      it "フィルタリング済みのスコープを返すべき" do
        @filter = TestFilter7.new(:title => "foo", :body => "bar")
        scope = @filter.to_scope
        scope.wheres.count.should eq(2)
        scope.wheres[0][:title].should eq("foo")
        scope.wheres[1][:body].should eq("bar")
      end
    end

    context "マッチするフィルタが複数あるとき" do
      class TestFilter11 < ::ActiveFilter::Base
        model TestEntry
        rule "^tit", ->(scope, value) { scope.where(:tit => value) }
        rule "^title$", ->(scope, value) { scope.where(:title => value) }
        rule "^body$", ->(scope, value) { scope.where(:body => value) }
      end

      it "最初にマッチしたルールでフィルタするスコープを返すべき" do
        @filter = TestFilter11.new(:title => "foo", :body => "bar")
        scope = @filter.to_scope
        scope.wheres.count.should eq(2)
        scope.wheres[0][:tit].should eq("foo")
        scope.wheres[1][:body].should eq("bar")
      end
    end
  end

  describe "#model" do
    class TestFilter8 < ::ActiveFilter::Base
      model TestEntry
    end

    it "指定したモデルの型を取得できるべき" do
      @filter = TestFilter8.new
      @filter.model.should eq(TestEntry)
    end
  end

  describe "#rules" do
    class TestFilter9 < ::ActiveFilter::Base
      rule "^foo$" do |scope, value| scope end
      rule "^bar$" do |scope, value| scope end
    end

    it "定義したルールを取得できるべき" do
      @filter = TestFilter9.new
      @filter.rules.size.should eq(2)
      @filter.rules[0].pattern.should eq("^foo$")
      @filter.rules[1].pattern.should eq("^bar$")
    end
  end
end

