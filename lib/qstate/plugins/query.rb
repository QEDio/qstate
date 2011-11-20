# -*- encoding: utf-8 -*-
require 'qstate/plugins/modules/generic'

module Qstate
  module Plugin
    class Query
      include Qstate::Plugin::Generic

      PREFIX                    = "q_"

      def self.prefix
        PREFIX
      end
    end
  end
end