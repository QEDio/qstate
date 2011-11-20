# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/../test_helper.rb'

class TestPluginConfidential < Test::Unit::TestCase
  include Qstate::Test::Plugin::Confidential
  
  context "creating a Confidential object" do
    setup do
      @confidential      = Qstate::Plugin::Confidential.new(:user => USER)
    end

    should "return the correct user value" do
      assert_equal USER, @confidential.user
    end

    should "return an empty uri string" do
      assert_nil @confidential.uri
    end

    context "and performing serialize/deserialize on it" do
      should "work with hash as data-interface" do
        assert_equal @confidential, Qstate::Plugin::Confidential.from_serializable_hash(@confidential.serializable_hash)
      end

      should "work with with deserialize" do
        assert_equal @confidential, Qstate::Plugin::Confidential.deserialize(@confidential.serializable_hash, :hash)
      end
    end
  end

  context "an empty Confidential object" do
    setup do
      @confidential = Qstate::Plugin::Confidential.new()
    end

    should "return false for 'present?'" do
      assert_equal false, @confidential.present?
    end

    should "return true for 'blank?'" do
      assert_equal true, @confidential.blank?
    end
  end
end