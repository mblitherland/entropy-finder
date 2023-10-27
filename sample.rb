# frozen_string_literal: true

# Just some sample strings to see what our entropy finder makes of them.
class Sample
  SOME_CONSTANT = 'abcdefghijklmnopqrstuvwxyz'
  @some_strings = [
    'password',
    'http://www.example.com/',
    'vapid private key: HEdOt8Yjl8Sq_9pMgunr6nlsLDZ78J8vV2T_DeWS0wU',
    'vapid public key: BKhSM-bUKX3eqc9kc46sialHnuPLMmmxnAfuUQd3-2H5EZf-vMGSP8TqB1yvO_NNgP9air_gco46yepVg8fXosA',
    "#{SOME_CONSTANT}+#{SOME_CONSTANT}-#{SOME_CONSTANT}*#{SOME_CONSTANT}/#{SOME_CONSTANT}",
    'The next thing is secret, but can fool the checker',
    'BKhSM' \
    '-bUKX' \
    '3eqc9' \
    'kc46s' \
    'ialHn' \
    'uPLMm' \
    'mxnAf' \
    'uUQd3' \
    '-2H5E' \
    'Zf-vM' \
    'GSP8T' \
    'qB1yv' \
    'O_NNg' \
    'P9air' \
    '_gco4' \
    '6yepV' \
    'g8fXosA'
  ]
end
