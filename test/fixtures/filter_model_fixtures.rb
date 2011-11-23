# -*- encoding: utf-8 -*-

require "uri"
module Qstate
  module Test
    module FilterModel
      include Qstate::Test::Base

      def self.create_uri(hsh)
        u = ""
        hsh.each_pair do |k,v|
          separator = u.eql?("") ? "" : "&"
          u += separator + k.to_s+"="+v.to_s
        end
        u
      end

      PARAMS_EMPTY                    =
        {
        }

      PARAMS_BASE                     =
        PARAMS_EMPTY


      PARAMS_VIEW                     =
        PARAMS_BASE.merge(
          {
            PREFIXED_VIEW                       =>  VIEW_VALUE
          }
        )

      PARAMS_RAILS                    =
        {
          ACTION                              =>  ACTION_VALUE,
          CONTROLLER                          =>  CONTROLLER_VALUE
        }

      PARAMS_DATETIME =
        {
          PREFIXED_STEP_SIZE                => STEP_SIZE_VALUE,
          PREFIXED_RESOLUTION               => RESOLUTION_VALUE,
          PREFIXED_FROM                     => FROM_VALUE,
          PREFIXED_TILL                     => TILL_VALUE
        }

      PARAMS_MAPREDUCE =
        {
          PREFIXED_EMIT_KEY_PRODUCT         => EMIT_KEY_PRODUCT_VALUE_DEFAULT_VALUE
        }

      PARAMS_QUERY =
        {
          PREFIXED_PRODUCT_NAME             =>  PRODUCT_NAME_VALUE
        }

      PARAMS_VIEW_DATETIME_MAPREDUCE =
        PARAMS_VIEW.merge(PARAMS_DATETIME).merge(PARAMS_MAPREDUCE)


      PARAMS_VIEW_DATETIME_MAPREDUCE_SPECIALCHARACTERS =
        PARAMS_VIEW_DATETIME_MAPREDUCE.merge(
          {
            PREFIXED_PRODUCT_NAME             =>  PRODUCT_NAME_VALUE_SPECIAL_CHARS
          }
      )

      PARAMS_ALL_PLUGINS_URI_ENCODEABLE =
        PARAMS_VIEW.merge(PARAMS_DATETIME).merge(PARAMS_MAPREDUCE).merge(PARAMS_QUERY)

      PARAMS_ALL_PLUGINS =
        #PARAMS_VIEW.merge(PARAMS_RAILS).merge(PARAMS_DATETIME).merge(PARAMS_MAPREDUCE)
        PARAMS_ALL_PLUGINS_URI_ENCODEABLE.merge(PARAMS_RAILS)

      PARAMS_BASE_URI                                                 =
        create_uri(PARAMS_BASE)

      PARAMS_BASE_URI_START                                           =
        "?" + PARAMS_BASE_URI

      PARAMS_BASE_URI_START_ENCODED                                   =
        URI.encode(PARAMS_BASE_URI_START)

      PARAMS_VIEW_DATETIME_MAPREDUCE_URI_START                        =
        "?"+create_uri(PARAMS_VIEW_DATETIME_MAPREDUCE)

      PARAMS_VIEW_DATETIME_MAPREDUCE_URI_START_ENCODED                =
        URI.encode(PARAMS_VIEW_DATETIME_MAPREDUCE_URI_START)

      PARAMS_VIEW_DATETIME_MAPREDUCE_SPECIALCHARACTERS_URI            =
        "?"+create_uri(PARAMS_VIEW_DATETIME_MAPREDUCE_SPECIALCHARACTERS)

      PARAMS_VIEW_DATETIME_MAPREDUCE_SPECIALCHARACTERS_URI_ENCODED    =
        URI.encode(PARAMS_VIEW_DATETIME_MAPREDUCE_SPECIALCHARACTERS_URI)

      PARAMS_ALL_PLUGINS_URI                                          =
        "?"+create_uri(PARAMS_ALL_PLUGINS_URI_ENCODEABLE)

      PARAMS_ALL_PLUGINS_URI_ENCODED                                  =
        URI.encode(PARAMS_ALL_PLUGINS_URI)

      URL_ROW                               = {"_id"=>{PREFIXED_PRODUCT_NAME=>PRODUCT_NAME_VALUE_GARAGE}, "value"=>{"product_name"=>"#{PRODUCT_NAME_VALUE_GARAGE}", "count"=>984.0, "worked_on"=>951.0, "qualified"=>497.0, "test"=>37.0, "turnover"=>19560.0, "payed"=>0.0, "product_uuid"=>"0892afe0b494012d895138ac6f7d89ab", "inquiry_id"=>185968}}
      URL_KEY                               = "product_name"
      URL_FIELD                             = PRODUCT_NAME_VALUE_GARAGE

      PARAMS_ALL_PLUGINS_DIGEST_SHA2_DIGEST         =   "4fc0ca43be7089dfa2fb0470c51dd07b45e9b2e5856d9a583396e7d0a874f9c5"
      PARAMS_ALL_PLUGINS_VIEW_CHANGED_SHA2_DIGEST   =   "84cb4231d379174fd729d14ffc818537ad6be1741b2a0e1b81626e9370674202"

      PARAMS_RESULTING_MONGODB_QUERY = '{:"value.created_at"=>{"$gte"=>2011-06-05 22:00:00 UTC, "$lt"=>2011-12-09 22:00:00 UTC}, "value.product_name"=>"Elektromobil"}'
    end
  end
end