# -*- encoding: utf-8 -*-
require 'qstate/plugins/modules/base'
require 'qstate/plugins/modules/uri'

module Qstate
  module Plugin
    class DateTime
      include Qstate::Plugin::Base
      include Qstate::Plugin::Uri

      PREFIX                    = "t_"
      FROM_ID                   = :from
      TILL_ID                   = :till
      STEP_SIZE_ID              = :step_size
      RESOLUTION_ID             = :resolution

      attr_accessor :from, :till, :step_size, :resolution

      def self.prefix
        PREFIX
      end

      def initialize(ext_options = {})
        options           = default_options.merge(ext_options)
        self.from         = options[FROM_ID]
        self.till         = options[TILL_ID]
        self.step_size    = options[STEP_SIZE_ID]
        self.resolution   = options[RESOLUTION_ID]
      end

      def default_options
        {
          STEP_SIZE_ID      => 0,
          RESOLUTION_ID        => 86399 # a whole day minus one second
        }
      end

      def serializable_hash
        {
          FROM_ID       => from,
          TILL_ID       => till,
          STEP_SIZE_ID  => step_size,
          RESOLUTION_ID    => resolution
        }
      end

      def from=(from)
        @from = self.class.convert_to_utc(from)
      end

      def till=(till)
        @till = self.class.convert_to_utc(till)
      end

      def step_size=(step_size)
        @step_size = step_size.to_i
      end

      def resolution=(resolution)
        @resolution = resolution.to_i
      end

      def uri_values(u, options)
        u = uri_for_key(u, STEP_SIZE_ID, step_size, options) if( step_size != default_options[STEP_SIZE_ID] )
        u = uri_for_key(u, RESOLUTION_ID, resolution, options) if( resolution != default_options[RESOLUTION_ID] )
        u = uri_for_key(u, FROM_ID, from, options) if(from.present?)
        u = uri_for_key(u, TILL_ID, till, options) if(till.present?)
        return u
      end

      def present?
        from.present? ||
        till.present? ||
        !step_size.eql?(default_options[STEP_SIZE_ID]) ||
        !resolution.eql?(default_options[RESOLUTION_ID])
      end

      def self.convert_to_utc(date)
        return nil if date.nil?

        if(date.is_a?(String))
          converted_date = Time.parse(date).utc
        elsif( date.is_a?(Time))
          converted_date = date
        else
          raise Exception.new("not supported yet, #{date.class}")
        end

        return converted_date
      end
    end
  end
end