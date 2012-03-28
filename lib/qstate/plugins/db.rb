# -*- encoding: utf-8 -*-
require 'qstate/plugins/modules/generic'

module Qstate
  module Plugin
    class Db
      include Qstate::Plugin::Base
      include Qstate::Plugin::Uri

      CACHE_ID                   = :cache

      attr_accessor :cache

      def self.prefix
        "d_"
      end

      def initialize(ext_options = {})
        options = default_options.merge(ext_options)

        @cache   = options[CACHE_ID]
      end

      def default_options
        {
            CACHE_ID           => nil
        }
      end

      def serializable_hash
        {
            CACHE_ID           => nil
        }
      end

      def uri_values(u, options)
        u = uri_for_key(u, CACHE_ID, view, options) if(cache.present?)

        return u
      end

      def present?
        cache.present?
      end
    end
  end
end