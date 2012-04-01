# -*- encoding: utf-8 -*-
require 'qstate/plugins/modules/generic'

module Qstate
  module Plugin
    class MapReduceAggregation < Qstate::Plugin::MapReduce
      def self.prefix
        "ma_"
      end
    end
  end
end