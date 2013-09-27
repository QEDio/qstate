require 'active_support/concern'

module Qstate
  module Plugin
    module Uri
      extend ActiveSupport::Concern

      module ClassMethods
        # Here the uri saga starts
        def from_uri(params)
          from_serializable_hash( uri_from_param(params) )
        end

        def uri_from_param(param)
          if param.is_a?(Hash)
            return uri_from_hash(param)
          elsif param.is_a?(String)
            return uri_from_string(param)
          elsif param.is_a?(Array)
            return uri_from_array(param)
          else
            raise Exception.new("Unknown type #{param.class}")
          end
        end

        def uri_from_array(params)
          hsh = {}

          params.each do |param|
            hsh = hsh.merge(uri_from_param(param))
          end

          return hsh
        end

        def uri_from_hash(params)
          symbolized_params = params.symbolize_keys_rec

          hsh = {}
          # find relevant parameters
          our_params = symbolized_params.select{|key, value| key.to_s.starts_with?(prefix)}

          # extract key name (in short replace PREFIX, e.g. :t_from becomes :from)
          # and add to hsh
          our_params.each_pair do |key, value|
            key.to_s =~ /(#{prefix})(.*)/
            hsh[$2.to_sym] = value if $2.present?
          end

          return hsh
        end

        def uri_from_string(params)
          hsh = {}

          # match all t_xz=abc& values
          # $1 = t_ (prefix)
          # $2 = xz
          # $3 = =
          # $4 = abc
          # $5 = & or nothing
          params.scan(/(#{prefix})(.*?)(=)(.*?)(&|$)/).each{|arr| hsh[arr[1].to_sym] = arr[3] }

          return hsh
        end
      end

      module InstanceMethods
        # uri generation wrapper method
        # You need to implement uri_values, everything else should be standard and reusable
        def uri(ext_options = {})

          options = default_uri_options.merge(ext_options)

          u = uri_init(options)

          # Needs to be implemented in including class!
          u = uri_values(u, options)

          u = uri_encode(u, options)
          u = uri_merge(u, options[:previous_uri_output])
          return u
        end

        # initialize uri params
        # set u if necessary to requested type, or leave it be (if not nil)
        # verify that requested type and provided param 'u' match type
        # Options:
        #   :type => (nil|:string|:hash)
        def uri_init(options)
          # initialize uri value for this run
          if options[:type].nil? || options[:type].eql?(:string)
            current_uri_output = ""
          elsif options[:type].eql?(:hash)
            current_uri_output = {}
          else
            raise Exception.new("Unknown return-type #{options[:type]}")
          end

          # deal with initial nil for previous_uri_output
          if options[:previous_uri_output].nil?
            options[:previous_uri_output] = current_uri_output
          end

          # previous_uri_output needs to be of same type than current_uri_output
          unless current_uri_output.class.eql?(options[:previous_uri_output].class)
            raise Exception.new("The previous uri output is of type #{options[:previous_uri_output].class}, but the requested uri output type is #{options[:type]}")
          end

          return current_uri_output
        end

        # default uri options
        # overwrite if necessary
        def default_uri_options
          {
            :previous_uri_output      => nil,
            :type                     => :string
          }
        end

        def uri_for_key(output, key, value, ext_options)
          raise Exception.new("Param output is not allowed to be nil!") if output.nil?

          options = ext_options.merge(uri_separator(output, ext_options))
          uri_key = "#{self.class.prefix}#{key.to_s}".to_sym

          if output.is_a?(String)
            # is the & char at the beginning desired?
            separator = options[:separator] ? Qstate::Constants::URI_PARAMS_SEPARATOR : ""
            output += separator + uri_for_value(uri_key, value, options)
          elsif output.is_a?(Hash)
            output[uri_key] = value
          else
            raise Exception.new("Unknown type #{options[:type]} I should produce!")
          end

          return output
        end

        # this implements the rails array parameter handling
        def uri_for_value(key, value, ext_options)
          ret_val = ''

          if value.is_a?(Array)
            if value.size == 1
              ret_val = "#{key.to_s}#{Qstate::Constants::URI_PARAMS_ASSIGN}#{value[0].to_s}"
            else
              separator = ''

              value.each do |v|
                ret_val += separator + key.to_s+"[]"+Qstate::Constants::URI_PARAMS_ASSIGN+v.to_s
                separator = Qstate::Constants::URI_PARAMS_SEPARATOR
              end
            end
          else
            ret_val = "#{key.to_s}#{Qstate::Constants::URI_PARAMS_ASSIGN}#{value.to_s}"
          end

          return ret_val
        end

        def uri_separator(output, ext_options)
          separator_hsh = {:separator => false}

          if output.present? || ext_options[:previous_uri_output].present?
            separator_hsh = {:separator => true}
          end
          
          return separator_hsh
        end

        def uri_encode(u, options)
          if u.present? && options[:encode] && options[:type].eql?(:string)
            u = URI.escape(u)
          end
          return u
        end

        def uri_merge(u, old_u)
          raise Exception.new("Params 'u' and 'old_u' don't match in class. 'u' is #{u.class}' but 'old_u' is #{old_u.class}") unless u.class.eql?(old_u.class)

          if u.is_a?(String)
            u = old_u + u
          elsif u.is_a?(Hash)
            u = old_u.merge(u)
          else
            raise Exception.new("Don't know how to merge class #{u.class}'")
          end

          return u
        end
      end
    end
  end
end