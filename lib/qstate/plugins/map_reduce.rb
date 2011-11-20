# -*- encoding: utf-8 -*-
require 'qstate/plugins/modules/generic'

module Qstate
  module Plugin
    class MapReduce
      include Qstate::Plugin::Generic

      PREFIX                    = "m_"

      def self.prefix
        PREFIX
      end
    end
  end
end