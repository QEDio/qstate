# -*- encoding: utf-8 -*-
module Qstate
  module Test
    module Base

      # Start: DateTIme-Plugin Params
      ### IDs
      FROM                                  = "from"
      TILL                                  = "till"
      STEP_SIZE                             = "step_size"
      RESOLUTION                            = "resolution"
      PREFIXED_FROM                         = "t_"+FROM
      PREFIXED_TILL                         = "t_"+TILL
      PREFIXED_STEP_SIZE                    = "t_"+STEP_SIZE
      PREFIXED_RESOLUTION                   = "t_"+RESOLUTION

      ### VAlues
      FROM_VALUE                            = "2011-06-05 22:00:00 UTC"
      FROM_DATE_VALUE_TIME                  = Time.parse(FROM_VALUE)
      FROM_DATE_TRACKING_VALUE              = "2011-07-10 22:00:00 UTC"

      TILL_VALUE                            = "2011-12-09 22:00:00 UTC"
      TILL_DATE_VALUE_TIME                  = Time.parse(TILL_VALUE)
      TILL_DATE_TRACKING_VALUE              = "2011-07-20 22:00:00 UTC"

      STEP_SIZE_VALUE                       = 7
      RESOLUTION_VALUE                      = 56
      # End: DateTIme-Plugin Params


      # Start: MapReduce-Plugin Params
      ### IDs
      EMIT_KEY_PRODUCT                      = "key_that_needs_to_be_set"
      PREFIXED_EMIT_KEY_PRODUCT             = "m_"+EMIT_KEY_PRODUCT

      ### Values
      EMIT_KEY_PRODUCT_VALUE_DEFAULT_VALUE  = -1
      EMIT_KEY_PRODUCT_VALUE_GARAGE         = "Garage"
      # End: MapReduce-Plugin Params

      # Start: Query-Plugin Params
      ### IDs
      PRODUCT_NAME                          = "product_name"
      PREFIXED_PRODUCT_NAME                 = "q_"+PRODUCT_NAME

      ### Values
      PRODUCT_NAME_VALUE                    = "Elektromobil"
      PRODUCT_NAME_VALUE_GARAGE             = "Garage"
      PRODUCT_NAME_VALUE_SPECIAL_CHARS      = "Ää, Öö, Üü"
      # End: Query-Plugin Params

      # Start: View-Plugin Params
      VIEW                                  = "view"
      ACTION                                = "action"
      CONTROLLER                            = "controller"
      PREFIXED_VIEW                         = "v_"+VIEW
      PREFIXED_ACTION                       = "v_"+ACTION
      PREFIXED_CONTROLLER                   = "v_"+CONTROLLER

      VIEW_VALUE                            = "jak4s view"
      ACTION_VALUE                          = "do something"
      CONTROLLER_VALUE                      = "dashboard"
      # End: View-Plugin Params

    end
  end
end