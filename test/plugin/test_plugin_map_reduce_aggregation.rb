# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/../test_helper.rb'
require 'uri'
require 'cgi'

class TestPluginMapReduceAggregation < Test::Unit::TestCase
  TEST_URI                      = 'http://api.qed.io?ma_id=[abc]&ma_id=[xyz]&ma_id2=[u]&ma_id2=[v]'
  #EMIT_KEYS_PARAMS_HASH         = CGI.parse(URI.parse(URI.encode(TEST_URI)).query).
  #                                  inject({}){|hsh,(k,v)| hsh[k] = v.map{|el| el.gsub("[","").gsub("]","")}}
  EMIT_KEYS_PARAMS_HASH         = {ma_id: ['abc', 'xyz'], ma_id2: ['u','v']}
  EMIT_KEYS_RESULT_HASH         = {
    values: [
      {
        key:      :id,
        value:    ['abc', 'xyz']
      },
      {
          key:      :id2,
          value:    ['u', 'v']
      }
    ]
  }

  context 'create a MapReduceAggregation Object from' do
    context 'a Rails like params hash' do
      setup do
        @mrap = Qstate::Plugin::MapReduceAggregation.deserialize(EMIT_KEYS_PARAMS_HASH, :uri)
      end

      should 'execute correctly' do
        assert_equal EMIT_KEYS_RESULT_HASH, @mrap.serializable_hash
      end
    end
  end
end