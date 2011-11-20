# -*- encoding: utf-8 -*-
require 'qaram/plugins/modules/base'
require 'qaram/plugins/modules/uri'

module Qaram
  module Plugin
    class View
      include Qaram::Plugin::Base
      include Qaram::Plugin::Uri

      PREFIX                    = "v_"
      VIEW_ID                   = :view
      ACTION_ID                 = :action
      CONTROLLER_ID             = :controller

      attr_accessor :controller, :action, :view

      def self.prefix
        PREFIX
      end

      def initialize(ext_options = {})
        options = default_options.merge(ext_options)

        self.controller   = options[CONTROLLER_ID]
        self.action       = options[ACTION_ID]
        self.view         = options[VIEW_ID]
      end

      def default_options
        {
          VIEW_ID           => nil,
          ACTION_ID         => nil,
          CONTROLLER_ID     => nil
        }
      end

      def serializable_hash
        {
          VIEW_ID         => view,
          CONTROLLER_ID   => controller,
          ACTION_ID       => action
        }
      end

      def uri_values(u, options)
        u = uri_for_key(u, VIEW_ID, view, options) if(view.present?)
        u = uri_for_key(u, ACTION_ID, action, options) if(action.present?)
        u = uri_for_key(u, CONTROLLER_ID, controller, options) if(controller.present?)
        return u
      end

      def present?
        view.present? || action.present? || controller.present?
      end
    end
  end
end