# -*- encoding: utf-8 -*-
require 'qstate/plugins/modules/generic'

module Qstate
  module Plugin
    class Db
      include Qstate::Plugin::Generic
      def self.prefix
        "d_"
      end
    end
  end
end