# coding: utf-8
require File.expand_path("../../spec_helper", __FILE__)

describe "Base" do
  describe "#initialize" do
    class TestFilter1 < ::ActiveFilter::Base
      model Task
      fields :name, :completed
    end

    context "data を指定したとき" do
      it "@data に指定した data が格納されているべき" do
        @filter = TestFilter1.new(:foo => "bar")

        actual = nil
        @filter.instance_eval { actual = @data[:foo] }
        actual.should eq("bar")
      end
    end

    context "data を指定しないとき" do
      it "@data に空の Hash が格納されているべき" do
        @filter = TestFilter1.new

        actual = nil
        @filter.instance_eval { actual = @data }
        actual.should be_empty
      end
    end

    context "scope を指定したとき" do
      before do
        FactoryGirl.create(:task, :name => "foo", :completed => true)
        FactoryGirl.create(:task, :name => "bar", :completed => true)
        FactoryGirl.create(:task, :name => "hoge")
      end

      it "指定したスコープをベースに絞り込む" do
        @filter = TestFilter1.new(Task.where(:name => "foo"), :completed => true)
        @filter.to_scope.count.should eq(1)
      end
    end
  end

  describe ".model" do
    context "ActiveRecord::Base を継承したクラスを指定したとき" do
      class TestFilter2 < ::ActiveFilter::Base
        model Task
      end

      it "model に指定したクラスが格納されているべき" do
        @filter = TestFilter2.new
        @filter.model.should eq(Task)
      end
    end

    context "ActiveRecord::Base を継承していないクラスを指定したとき" do
      it "ArgumentError が発生するべき" do
        proc {
          class TestFilter10 < ::ActiveFilter::Base
            model String
          end
        }.should raise_error(ArgumentError)
      end
    end
  end

  describe ".fields" do
    class TestFilter6 < ::ActiveFilter::Base
      model Task
      fields :name, :completed
    end

    it "#fields にフィールドが格納されているべき" do
      @filter = TestFilter6.new
      @filter.fields.size.should eq(2)
      @filter.fields[0].name.should eq("name")
      @filter.fields[1].name.should eq("completed")
    end
  end

  describe "#to_scope" do
    context "マッチするフィルタが１つだけのとき" do
      class TestFilter7 < ::ActiveFilter::Base
        model Task
        fields :name
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

    context "マッチするフィルタが無いとき" do
      class TestFilter11 < ::ActiveFilter::Base
        model Task
        fields :name
      end

      before do
        FactoryGirl.create(:task, :name => "foo")
      end

      it "データを0件返すべき" do
        @filter = TestFilter11.new(:completed => true)
        scope = @filter.to_scope
        scope.count.should eq(0)
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

  describe "#fields" do
    class TestFilter9 < ::ActiveFilter::Base
      model Task
      fields :name, :completed
    end

    it "定義したフィールドを取得できるべき" do
      @filter = TestFilter9.new
      @filter.fields.size.should eq(2)
      @filter.fields[0].name.should eq("name")
      @filter.fields[1].name.should eq("completed")
    end
  end
end

