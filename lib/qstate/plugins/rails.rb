# -*- encoding: utf-8 -*-
require 'qstate/plugins/modules/base'
require 'qstate/plugins/modules/default_implementations'

module Qstate
  module Plugin
    class Rails
      include Qstate::Plugin::Base
      include Qstate::Plugin::DefaultImplementations

      PREFIX                    = ''
      ACTION_ID                 = :action
      CONTROLLER_ID             = :controller

      attr_accessor :controller, :action

      def self.prefix
        PREFIX
      end

      def initialize(ext_options = {})
        options = default_options.merge(ext_options)

        self.controller   = options[CONTROLLER_ID]
        self.action       = options[ACTION_ID]
      end

      def default_options
        {
          ACTION_ID         => nil,
          CONTROLLER_ID     => nil
        }
      end

      def serializable_hash
        {
          CONTROLLER_ID   => controller,
          ACTION_ID       => action
        }
      end

      def present?
        action.present? || controller.present?
      end
    end
  end
end

