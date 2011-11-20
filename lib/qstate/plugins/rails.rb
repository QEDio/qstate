# -*- encoding: utf-8 -*-
require 'qaram/plugins/modules/base'
require 'qaram/plugins/modules/default_implementations'

module Qaram
  module Plugin
    class Rails
      include Qaram::Plugin::Base
      include Qaram::Plugin::DefaultImplementations

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

