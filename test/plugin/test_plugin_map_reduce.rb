# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/../test_helper.rb'

class TestPluginMapReduce < Test::Unit::TestCase
  include Qaram::Test::Plugin::MapReduce
  context "create a MapReduceParams Object from" do
    context "a params like from the webbrowser" do
      setup do
        @mrp = Qaram::Plugin::MapReduce.deserialize(EMIT_KEYS_LIKE_URL_PARAMS, :uri)
      end

      should "execute correctly" do
        assert_equal EMIT_KEYS_RESULTS_HASH, @mrp.serializable_hash
      end
    end

    context "an empty hash" do
      setup do
        @mrp = Qaram::Plugin::MapReduce.new()
      end

      should "return false for method 'present?'" do
        assert_equal false, @mrp.present?
      end

      should "return true for method 'blank?'" do
        assert_equal true, @mrp.blank?
      end

      context "and adding map reduce params later via add_emit_key with key and value parameters" do
        setup do
          @mrp.add_value(EMIT_KEY1, :value => EMIT_VALUE1)
          @mrp.add_value(EMIT_KEY2, :value => EMIT_VALUE2)
        end

        should "generate the correct hash" do
          assert_equal EMIT_KEYS_RESULTS_HASH, @mrp.serializable_hash
        end

        should "generate the correct params in url format" do
          assert_equal EMIT_AS_URL, @mrp.uri
        end
      end

      context "and adding duplicate map reduce params later via add_emit_key with key and value parameters" do
        setup do
          @mrp.add_value(EMIT_KEY1, :value => EMIT_VALUE1)
          @mrp.add_value(EMIT_KEY2, :value => EMIT_VALUE2)
          @mrp.add_value(EMIT_KEY1, :value => EMIT_VALUE1)
          @mrp.add_value(EMIT_KEY2, :value => EMIT_VALUE2)
          @mrp.add_value(EMIT_KEY1, :value => EMIT_VALUE1)
          @mrp.add_value(EMIT_KEY2, :value => EMIT_VALUE2)
        end

        should "rejected the all but the latest duplicate generate the correct hash" do
          assert_equal EMIT_KEYS_RESULTS_HASH, @mrp.serializable_hash
        end

        should "generate the correct params in url format" do
          assert_equal EMIT_AS_URL, @mrp.uri
        end
      end

      context "and adding one map reduce param later via add_emit_key with key only" do
        setup do
          @mrp.add_value(EMIT_KEY1)
        end

        should "create the correct url with default value -1" do
          assert_equal EMIT_AS_URL_KEY1_VALUE_DEFAULT, @mrp.uri
        end

        should "return an integer as value if accessed directly" do
          assert_equal 1, @mrp.values.size
          assert @mrp.values.first.value.is_a?(Fixnum), "Should be an fixnum-object, but is #{@mrp.values.first.value.class}"
          assert_equal EMIT_VALUE_DEFAULT, @mrp.values.first.value
        end
      end
    end
  end
end