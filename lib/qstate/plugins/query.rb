# -*- encoding: utf-8 -*-
require 'qaram/plugins/modules/generic'

module Qaram
  module Plugin
    class Query
      include Qaram::Plugin::Generic

      PREFIX                    = "q_"

      def self.prefix
        PREFIX
      end
    end
  end
end