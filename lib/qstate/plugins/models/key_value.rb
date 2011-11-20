module Qaram
  module Plugin
    module Model
      class KeyValue
        attr_accessor :key, :value
        DEFAULT_VALUE     = -1

        def self.clone(key_value)
          KeyValue.new(key_value.key, key_value.value)
        end

        def initialize(key, value)
          raise Exception.new("Param 'key' is not allowed to be nil!") if key.nil?
          @key = key.to_sym
          @value = []

          add(value)
        end

        # Add a value. The method append a value to the value-array
        #
        # @example Add a String-obj
        #   keyvalue.add("abc")
        # @example Add an Array of String-Obj
        #   keyvalue.add(["abc", "def", "zyx"])

        def add(v)
          return if v.nil?
          return if v.eql?(DEFAULT_VALUE)
          return if v.eql?(DEFAULT_VALUE.to_s)

          Array(v).each do |vv|
            @value << vv
          end
        end

        def clone
          KeyValue.clone(self)
        end

        def value
          @value.size == 0 ? DEFAULT_VALUE : @value
        end

        def serializable_hash
          {
            :key              => @key,
            :value            => value
          }
        end
      end
    end
  end
end