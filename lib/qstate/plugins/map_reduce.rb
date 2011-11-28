# -*- encoding: utf-8 -*-
require 'qstate/plugins/modules/generic'

module Qstate
  module Plugin
    class MapReduce
      include Qstate::Plugin::Generic
      def self.prefix
        "m_"
      end
    end
  end
end