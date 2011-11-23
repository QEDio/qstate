# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/../test_helper.rb'

class TestPluginDataTime < Test::Unit::TestCase
  include Qstate::Test::Plugin::DateTime

  context "creating a fully equipped DateTime object" do
    setup do
      @date_time      = Qstate::Plugin::DateTime.new(:from => FROM_STR, :till => TILL_STR, :step_size => 1, :resolution => RESOLUTION)
    end

    should "return the correct from value" do
      assert_equal FROM_TIME.utc, @date_time.from
    end

    should "return the correct till value" do
      assert_equal TILL_TIME.utc, @date_time.till
    end

    should "return the correct step size" do
      assert_equal 1, @date_time.step_size
    end

    should "return the correct resolution" do
      assert_equal RESOLUTION, @date_time.resolution
    end

    context "and performing serialize/deserialize on it" do
      should "work with hash as data-interface" do
        assert_equal @date_time, Qstate::Plugin::DateTime.from_serializable_hash(@date_time.serializable_hash)
      end

      should "work with uri-string as data-interface " do
        assert_equal @date_time, Qstate::Plugin::DateTime.from_uri(@date_time.uri)
      end

      should "work with uri-hash as data-interface" do
        assert_equal @date_time, Qstate::Plugin::DateTime.from_uri(@date_time.uri(:type => :hash))
      end

      should "work with with deserialize" do
        assert_equal @date_time, Qstate::Plugin::DateTime.deserialize(@date_time.serializable_hash, :hash)
        assert_equal @date_time, Qstate::Plugin::DateTime.deserialize(@date_time.uri, :uri)
        assert_equal @date_time, Qstate::Plugin::DateTime.deserialize(@date_time.uri(:type => :hash), :uri)
      end
    end
  end

  context "creating a partially set DateTime object" do
    setup do
      @date_time  = Qstate::Plugin::DateTime.new(:from => "2011-01-01")
    end

    should "return correct uri" do
      assert_equal "t_from=#{Time.new(2011,01,01).utc}", @date_time.uri
    end
  end

  context "an empty DateTime object" do
    setup do
      @date_time = Qstate::Plugin::DateTime.new()
    end

    should "return false for method 'present?'" do
      assert_equal false, @date_time.present?
    end

    should "return true for method 'blank?'" do
      assert_equal true, @date_time.blank?
    end
  end
end