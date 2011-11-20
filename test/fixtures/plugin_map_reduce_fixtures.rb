module Qstate
  module Test
    module Plugin
      module MapReduce

        EMIT_KEY1                           = 'campaign_product'
        PREFIXED_EMIT_KEY1                  = 'm_' + EMIT_KEY1
        EMIT_VALUE1                         = '1'
        EMIT_KEY2                           = 'campaign_holding'
        PREFIXED_EMIT_KEY2                  = 'm_' + EMIT_KEY2
        EMIT_VALUE2                         = '2'
        EMIT_VALUE_DEFAULT                  = -1
        EMIT_AS_URL                         = PREFIXED_EMIT_KEY1 + "=" + EMIT_VALUE1 + "&" + PREFIXED_EMIT_KEY2 + "=" + EMIT_VALUE2
        EMIT_AS_URL_KEY1_VALUE_DEFAULT      = PREFIXED_EMIT_KEY1 + "=" + EMIT_VALUE_DEFAULT.to_s


        EMIT_KEYS_LIKE_URL_PARAMS     = [
          PREFIXED_EMIT_KEY1 + "=" + EMIT_VALUE1,
          PREFIXED_EMIT_KEY2 + "=" + EMIT_VALUE2
        ]

        #EMIT_KEYS_LIKE_HASH           = [
        #  {:key => PREFIXED_EMIT_KEY1,       :value => EMIT_VALUE1},
        #  {:key => PREFIXED_EMIT_KEY2,       :value => EMIT_VALUE2}
        #]

        EMIT_KEYS_RESULTS_HASH =
        { :values  => [
            { :key    =>  :campaign_product,
              :value  =>  ["1"]
            },
            { :key    =>  :campaign_holding,
              :value  =>  ["2"]}
          ]
        }

        #EMIT_KEYS_LIKE_ARRAY           = [
        #  [PREFIXED_EMIT_KEY1, EMIT_VALUE1],
        #  [PREFIXED_EMIT_KEY2, EMIT_VALUE2]
        #]
      end
    end
  end
end