# -*- encoding: utf-8 -*-
require 'qaram/plugins/modules/base'
require 'qaram/plugins/modules/default_implementations'

module Qaram
  module Plugin
    class Confidential
      include Qaram::Plugin::Base
      include Qaram::Plugin::DefaultImplementations

      USER_ID       = :user
      attr_accessor :user

      def self.prefix
        raise Exception.new("This is not the serialization you are looking for!")
      end

      def self.known_representations
        [:json, :hash]
      end

      def initialize(ext_options = {})
        options     = default_options.merge(ext_options)
        self.user   = options[:user]
      end

      def default_options
        {
        }
      end

      def serializable_hash
        {
          USER_ID       => user
        }
      end

      def present?
        user.present?
      end
    end
  end
end