# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/../../test_helper.rb'

class TestClassesKeyValue < Test::Unit::TestCase
  context "creating an empty KeyValue-Object" do
    setup do
      @kv = Qaram::Plugin::Model::KeyValue
    end

    should "set 'value' to DEFAULT_VALUE" do

    end
  end
end
