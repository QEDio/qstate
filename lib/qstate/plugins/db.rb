# -*- encoding: utf-8 -*-
require 'qstate/plugins/modules/generic'

module Qstate
  module Plugin
    class Db
      include Qstate::Plugin::Base
      include Qstate::Plugin::Uri

      CACHE_ID                    = :cache

      CACHE_VALUE_TRUE            = [ 't', 'true' ]
      CACHE_VALUE_FALSE           = [ 'f', 'false' ]
      CACHE_VALUE_RENEW           = [ 'r', 'renew']

      CACHE_VALUES                = CACHE_VALUE_TRUE + CACHE_VALUE_FALSE + CACHE_VALUE_RENEW

      # string, supported values: true/t, false/f, renew/r
      attr_reader :cache

      def self.prefix
        "d_"
      end

      def initialize(ext_options = {})
        options = default_options.merge(ext_options)

        self.cache = options[CACHE_ID]
      end

      def cache=(c)
        if CACHE_VALUES.include?(c)
          @cache = c
        else
          raise "Unknown Value for variable cache: #{c}"
        end

        self
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