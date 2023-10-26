# frozen_string_literal: true

# Just some sample strings to see what our entropy finder makes of them.
class Sample
  SOME_CONSTANT = 'abcdefghijklmnopqrstuvwxyz'
  @some_strings = [
    'password',
    'http://www.example.com/',
    'vapid private key: HEdOt8Yjl8Sq_9pMgunr6nlsLDZ78J8vV2T_DeWS0wU',
    'vapid public key: BKhSM-bUKX3eqc9kc46sialHnuPLMmmxnAfuUQd3-2H5EZf-vMGSP8TqB1yvO_NNgP9air_gco46yepVg8fXosA',
    "#{SOME_CONSTANT}+#{SOME_CONSTANT}-#{SOME_CONSTANT}*#{SOME_CONSTANT}/#{SOME_CONSTANT}"
  ]
end
