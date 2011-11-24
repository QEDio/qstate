# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/test_helper.rb'

class TestFilterModel < Test::Unit::TestCase
  include Qstate::Test::FilterModel

  context "creating a filtermodel from a rails params hash with two plugins" do
    setup do
      @fm = Qstate::FilterModel.new(PARAMS_VIEW_DATETIME_MAPREDUCE)
    end

    should "initialize the correct number of plugin objects" do
      assert_equal 3, @fm.plugins.size
    end

    should "correctly set the DateTime-Plugin-Object" do
      date_time = @fm.get_plugins(Qstate::Plugin::DateTime)
      assert_equal 1, date_time.size
      date_time = date_time[0]

      assert_equal FROM_DATE_VALUE_TIME, date_time.from
      assert_equal TILL_DATE_VALUE_TIME, date_time.till
      assert_equal STEP_SIZE_VALUE, date_time.step_size
    end

    should "correctly set the MapReduce-Plugin-Object" do
      map_reduce = @fm.get_plugins(Qstate::Plugin::MapReduce)
      assert_equal 1, map_reduce.size
      map_reduce = map_reduce[0]

      assert_equal EMIT_KEY_PRODUCT_VALUE_DEFAULT_VALUE, map_reduce.get_value(EMIT_KEY_PRODUCT.to_sym).value
    end

    should "convert to json and back again" do
      json = @fm.json
      new_fm = Qstate::FilterModel.new(json, :type => :json)
      assert_equal @fm, new_fm
    end

    should "generate the correct URI" do
      assert_equal PARAMS_VIEW_DATETIME_MAPREDUCE_URI_START, @fm.uri(:encode => false)
    end

    should "generate the correct URI encoded" do
      assert_equal PARAMS_VIEW_DATETIME_MAPREDUCE_URI_START_ENCODED, @fm.uri(:encode => true)
      assert_equal PARAMS_VIEW_DATETIME_MAPREDUCE_URI_START_ENCODED, @fm.uri
    end

    context "and resetting values " do
      setup do
        @fm.confidential.user = "test_user"
        @fm.view.view = "some_view"
      end

      should "set the view value correctly" do
        assert_equal "some_view", @fm.view.view
      end

      should "set the user value correctly" do
        assert_equal "test_user", @fm.confidential.user
      end
    end
  end

  context "creating a filtermodel from a rails params with special characters" do
    setup do
      @fm = Qstate::FilterModel.new(PARAMS_VIEW_DATETIME_MAPREDUCE_SPECIALCHARACTERS)
    end

    should "escape the special characters in the url" do
      assert_equal PARAMS_VIEW_DATETIME_MAPREDUCE_SPECIALCHARACTERS_URI_ENCODED, @fm.uri
    end
  end

  context "creating a filtermodel from a rails params hash with all plugins" do
    setup do
      @fm = Qstate::FilterModel.new(PARAMS_ALL_PLUGINS)
      @fm.plugins << Qstate::Plugin::Confidential.new(:user => "tester")
      @fm.plugins << Qstate::Plugin::Rails.new(:controller => "suppa_controller")
    end

    should "create all plugins" do
      assert_equal Qstate::FilterModel.registered_plugins.size, @fm.plugins.size
    end

    should "return a wonderful looking uri" do
      assert_equal PARAMS_ALL_PLUGINS_URI_ENCODED, @fm.uri
    end

    context "and looking at it's digest'" do
      setup do
        @digest = @fm.digest
      end

      should "create a valid cloned filtermodel" do
        assert_equal @digest, @fm.clone.digest
      end

      should "create a different digest for a different state" do
        fm_cloned = @fm.clone
        fm_cloned.view.view = "different view"
        assert_not_equal @fm.digest, fm_cloned.digest
      end
    end

    context "and looking at the view plugin in detail" do
      setup do
        @view = @fm.view
      end

      should "have the correct view name" do
        assert_equal VIEW_VALUE, @view.view
      end
    end

    context "and looking at the query plugin in detail" do
      setup do
        @query = @fm.query
      end

      should "have the correct number of values" do
        assert_equal PARAMS_QUERY.size, @query.values.size
      end

      should "have the correct value" do
        assert_equal PRODUCT_NAME_VALUE, @query.values.first.value.first
      end
    end
  end

  context "creating a filtermodel with an empty hash" do
    setup do
      @fm     = Qstate::FilterModel.new(PARAMS_EMPTY)
    end

    should "initialize no plugins" do
      assert_equal 0, @fm.plugins.size
    end

    context "and looking at the mapreduce plugin" do
      should "return nil for map_reduce_params" do
        assert_equal false, @fm.mapreduce.present?
      end
    end

    context "and setting the user without the appropriate plugin" do
      setup do
        @fm.confidential.user = "test_user"
      end

      should "create one plugin" do
        assert_equal 1, @fm.plugins.size
      end

      should "create the confidential plugin" do
        assert_equal Qstate::Plugin::Confidential, @fm.confidential.class
      end

      should "set the correct user value within the confidential plugin" do
        assert_equal "test_user", @fm.confidential.user
      end
    end

    context "and setting the view without the appropriate plugin" do
      setup do
        @fm.view.view = "some_view"
      end

      should "create the confidential plugin" do
        assert_equal Qstate::Plugin::View, @fm.view.class
      end

      should "set the correct user value within the confidential plugin" do
        assert_equal "some_view", @fm.view.view
      end
    end

    context "and adding the same query key twice with replace => false" do
      setup do
        @fm.query.add_value("key1", :value => "value1")
        @fm.query.add_value("key1", :value => "value2", :replace => false)
      end

      should "not create a new KeyValue-Object" do
        assert_equal 1, @fm.query.values.size
      end

      should "add the second value to the correct KeyValue-Object" do
        assert_equal 2, @fm.query.values.first.value.size
      end

      should "have the correct values for both in the KeyValue-Object" do
        assert_equal "value1", @fm.query.values.first.value[0]
        assert_equal "value2", @fm.query.values.first.value[1]
      end

      should "have create an uri with an array" do
        assert_equal "?q_key1[]=value1&q_key1[]=value2", @fm.uri
      end
    end

    context "and overwriting each plugin with an external one" do
      setup do
        @query            = Qstate::Plugin::Query.new(:key => "a", :value => "b")
        @view             = Qstate::Plugin::View.new(:view => "view")
        @mapreduce        = Qstate::Plugin::MapReduce.new(:key => "x", :value => "z")
        @mapreduce_emtpy  = Qstate::Plugin::MapReduce.new()
        @fm.query         = @query
        @fm.view          = @view
      end

      should "return the newly set plugins" do
        assert_equal @query, @fm.query
        assert_equal @view, @fm.view
      end

      should "not return not newly set plugins, but the empty ones" do
        assert_equal      @mapreduce_emtpy, @fm.mapreduce
        assert_not_equal  @mapreduce, @fm.mapreduce
      end

      should "throw an exception if tyring to set a plugin with the wrong type" do
        assert_raise Exception do
          @fm.mapreduce = "string"
        end
      end
    end
  end
end


