# -*- encoding: utf-8 -*-
require 'qstate/plugins/modules/generic'

module Qstate
  module Plugin
    class Query
      include Qstate::Plugin::Generic
      def self.prefix
        "q_"
      end
    end
  end
end