require 'active_support/concern'

module Qstate
  module Plugin
    module Base
      extend ActiveSupport::Concern

      module ClassMethods
        def deserialize(params, type)
          unless known_representations.include?(type)
            raise Exceptions::RepresentationNotSupported.new("Unknown representation type #{type}. I know about #{known_representations.inspect}")
          end

          case type
            when :hash  then from_serializable_hash(params)
            when :uri   then from_uri(params)
            when :json  then from_json(params)
            else raise Exception.new("Implement me")
          end
        end

        def clone(obj)
          from_serializable_hash(obj.serializable_hash)
        end

        def from_serializable_hash(hsh)
          raise Exception.new("Param hsh needs to be of type 'Hash', but is #{hsh.class}") unless hsh.is_a?(Hash)
          new(hsh.symbolize_keys_rec)
        end

        def from_json(params)
          hsh = params

          if(params.is_a?(String))
            hsh = Yajl::Parser.parse(params).symbolize_keys_rec
          end

          # use this hsh to create object
          from_serializable_hash(hsh)
        end

        # TODO: you should overwrite this function in the including class, but it's not required
        def known_representations
          [:uri, :json, :hash]
        end

        # TODO: Overwrite this function in the class including this module
        def prefix
          raise Exception.new('Sorry, but this one CLASS methods needs to be implemented!')
        end
      end

      module InstanceMethods
        def eql?(other)
          serializable_hash == other.serializable_hash
        end

        def ==(other)
          eql?(other)
        end

        def clone
          self.class.clone(self)
        end

        def present?
          return true
        end

        def blank?
          !present?
        end
      end
    end
  end
end