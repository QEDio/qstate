# -*- encoding: utf-8 -*-
require 'qaram/plugins/modules/generic'

module Qaram
  module Plugin
    class MapReduce
      include Qaram::Plugin::Generic

      PREFIX                    = "m_"

      def self.prefix
        PREFIX
      end
    end
  end
end