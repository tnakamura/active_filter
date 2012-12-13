# coding: utf-8
require File.expand_path("../../spec_helper", __FILE__)

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
      model Task
    end

    it "model に指定したクラスが格納されているべき" do
      @filter = TestFilter2.new
      @filter.model.should eq(Task)
    end
  end

  describe ".rule" do
    context "ブロックを指定したとき" do
      class TestFilter3 < ::ActiveFilter::Base
        model Task 
        rule "^name$" do |scope, value| scope.where(:name => value) end;
      end

      it "#rules にルールが格納されているべき" do
        @filter = TestFilter3.new
        @filter.rules.size.should eq(1)
        @filter.rules[0].pattern.should eq("^name$")
      end
    end

    context "ラムダ式を指定したとき" do
      class TestFilter4 < ::ActiveFilter::Base
        model Task
        rule "^name$", lambda { |scope, value| scope.where(:name => value) }
      end

      it "#rules にルールが格納されているべき" do
        @filter = TestFilter4.new
        @filter.rules.size.should eq(1)
        @filter.rules[0].pattern.should eq("^name$")
      end
    end

    context "ラムダ式とブロックを両方指定しなかったとき" do
      it "例外が発生するべき" do
        expect {
          class TestFilter10 < ::ActiveFilter::Base
            model Task
            rule "^foo$"
          end
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".field" do
    class TestFilter5 < ::ActiveFilter::Base
      model Task
      field :name
    end

    it "#rules にルールが格納されているべき" do
      @filter = TestFilter5.new
      @filter.rules.size.should eq(1)
      @filter.rules[0].pattern.should eq("^name$")
    end
  end

  describe ".fields" do
    class TestFilter6 < ::ActiveFilter::Base
      model Task
      fields :name, :completed
    end

    it "#rules にルールが格納されているべき" do
      @filter = TestFilter6.new
      @filter.rules.size.should eq(2)
      @filter.rules[0].pattern.should eq("^name$")
      @filter.rules[1].pattern.should eq("^completed$")
    end
  end

  describe "#to_scope" do
    context "マッチするフィルタが１つだけのとき" do
      class TestFilter7 < ::ActiveFilter::Base
        model Task
        field :name
      end

      before do
        FactoryGirl.create(:task, :name => "foo")
      end

      it "フィルタリング済みのスコープを返すべき" do
        @filter = TestFilter7.new(:name => "foo", :completed => true)
        scope = @filter.to_scope
        scope.count.should eq(1)
        scope.first.name.should eq("foo")
      end
    end

    context "マッチするフィルタが複数あるとき" do
      class TestFilter11 < ::ActiveFilter::Base
        model Task
        rule "^nam", ->(scope, value) { scope.where(:name => value) }
        rule "^name$", ->(scope, value) { scope.where(:name => value) }
      end

      before do
        FactoryGirl.create(:task, :name => "foo")
      end

      it "最初にマッチしたルールでフィルタするスコープを返すべき" do
        @filter = TestFilter11.new(:name => "foo", :completed => true)
        scope = @filter.to_scope
        scope.count.should eq(1)
        scope.first.name.should eq("foo")
      end
    end
  end

  describe "#model" do
    class TestFilter8 < ::ActiveFilter::Base
      model Task
    end

    it "指定したモデルの型を取得できるべき" do
      @filter = TestFilter8.new
      @filter.model.should eq(Task)
    end
  end

  describe "#rules" do
    class TestFilter9 < ::ActiveFilter::Base
      model Task
      rule "^name$" do |scope, value| scope end
      rule "^completed$" do |scope, value| scope end
    end

    it "定義したルールを取得できるべき" do
      @filter = TestFilter9.new
      @filter.rules.size.should eq(2)
      @filter.rules[0].pattern.should eq("^name$")
      @filter.rules[1].pattern.should eq("^completed$")
    end
  end
end

