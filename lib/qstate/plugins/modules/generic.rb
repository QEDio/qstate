# -*- encoding: utf-8 -*-
require 'qstate/plugins/modules/base'
require 'qstate/plugins/modules/uri'
require 'qstate/plugins/models/key_value'

module Qstate
  module Plugin
    module Generic
      extend ActiveSupport::Concern

      include Qstate::Plugin::Base
      include Qstate::Plugin::Uri
            
      KNOWN_REPRESENTATIONS     = [:uri, :json, :hash]

      module ClassMethods

      end
      
      module InstanceMethods
        attr_reader :values

        def initialize(ext_options = {})
          options         = default_options.merge(ext_options)
          @values      = []

          if options.key?(:values)
            add_values(Array(options[:values]))
          else
            # remove all keys we don't want to add here
            add_values(Array(options))
          end
        end

        def default_options
          {
          }
        end

        # Add a key-value pairs to the values attribute
        #
        # @example Add a string to the values-attribute
        #   generic.add_values(["param=value"])
        # @example Add a hash to the values-attribute
        #   generic.add_values([{:key => 'key', :value => 'value'}])
        #
        # @options ext_options [ true, false] :multiple_values Allow a key to have multiple values assigned 
        def add_values(values = [], ext_options = {})
          options   = default_add_values_options.merge(ext_options)

          raise Exception.new("values need to be an array") unless values.is_a?(Array)
          return if values.size == 0

          if values.first.is_a?(Array)
            values.each {|value| add_value(value[0], options.merge({:value => value[1]}))}
          elsif values.first.is_a?(Hash)
            values.each {|value| add_value(value[:key], options.merge({:value => value[:value]}))}
          elsif values.first.is_a?(String)
            values.each {|value| add_value(value, options)}
          elsif values.first.is_a?(KeyValue)
            values.each {|value| add_value(value.key, options.merge({:value => value.value}))}
          else
            raise Exception.new("The type #{values.first.class} is not supported as type in values")
          end
        end

        # Default options for method add_values
        def default_add_values_options
          {
            :replace => true
          }
        end

        def add_value(key, ext_options = {})
          options   = default_add_value_options.merge(ext_options)
          raise Exception.new("Param 'key' is not allowed to be nil!") if key.nil?

          k = key
          v = options[:value]

          # if we get something like "param=value"
          if key.is_a?(String)
            splitted_key = key.split("=")
            k = splitted_key[0].to_sym
            v = v || splitted_key[1]
          end

          # do we already have a KeyValue-Object with the current key?
          if has_value?(k)
            if options[:replace]
              replace_value(Model::KeyValue.new(k, v))
            else
              get_value(k).add(v)
            end
          else
            @values << Model::KeyValue.new(k, v)
          end
        end

        def default_add_value_options
          {
            :replace  => true,
            :value    => nil
          }
        end

        def has_value?(key)
          !get_value(key).nil?
        end

        # return the nil or one KeyValue Object with the supplied key
        # it's not possible to have two KeyValues with the same key
        def get_value(key)
          @values.select{|emit_key| emit_key.key.eql?(key)}.first
        end

        def delete_value(key)
          @values = @values.each.reject{|emit_key| emit_key.key.eql?(key)}
        end

        def replace_value(key_val)
          delete_value(key_val.key)
          @values << key_val
        end

        def uri_values(u, options)
          values.each do |emit_key|
            u = uri_for_key(u, emit_key.key, emit_key.value, options) if(emit_key.value.present?)
          end

          return u
        end

        def serializable_hash
          {
            :values      => @values.collect(&:serializable_hash)
          }
        end

        def present?
          values.present?
        end
      end
    end
  end
end