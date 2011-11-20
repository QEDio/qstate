# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/../test_helper.rb'

class TestPluginRails < Test::Unit::TestCase
  include Qstate::Test::Plugin::Rails
  
  context "creating a Rails object" do
    setup do
      @rails      = Qstate::Plugin::Rails.new(:action => ACTION, :controller => CONTROLLER)
    end

    should "return the correct action value" do
      assert_equal ACTION, @rails.action
    end

    should "return the correct controller value" do
      assert_equal CONTROLLER, @rails.controller
    end

    context "and performing serialize/deserialize on it" do
      should "work with hash as data-interface" do
        assert_equal @rails, Qstate::Plugin::Rails.from_serializable_hash(@rails.serializable_hash)
      end

      should "work with with deserialize" do
        assert_equal @rails, Qstate::Plugin::Rails.deserialize(@rails.serializable_hash, :hash)
      end
    end
  end

  context "An empty Rails object" do
    setup do
      @rails = Qstate::Plugin::Rails.new()
    end

    should "return false for 'present?'" do
      assert_equal false, @rails.present?
    end

    should "return true for 'blank?'" do
      assert_equal true, @rails.blank?
    end
  end
end