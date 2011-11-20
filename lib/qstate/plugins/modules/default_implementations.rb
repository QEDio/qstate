require 'active_support/concern'

module Qaram
  module Plugin
    module DefaultImplementations
      extend ActiveSupport::Concern

      module ClassMethods
        def prefix
          ''
        end

        def from_uri(options)
          new({})
        end
      end

      module InstanceMethods
        def uri(options = {})
          nil
        end

        def uri_values(u, options)
          nil
        end
      end
    end
  end
end