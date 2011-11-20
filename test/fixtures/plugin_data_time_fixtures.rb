# -*- encoding: utf-8 -*-
module Qstate
  module Test
    module Plugin
      module DateTime
        FROM_STR        = "2011-01-01"
        TILL_STR        = "2011-01-02"
        RESOLUTION      = 56

        FROM_TIME       = ::Time.parse(FROM_STR)
        TILL_TIME       = ::Time.parse(TILL_STR)
      end
    end
  end
end

