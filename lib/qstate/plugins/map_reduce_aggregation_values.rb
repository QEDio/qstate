# -*- encoding: utf-8 -*-
require 'qstate/plugins/modules/generic'

module Qstate
  module Plugin
    class MapReduceAggregationValues < Qstate::Plugin::MapReduce
      def self.prefix
        "mv_"
      end
    end
  end
end