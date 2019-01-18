### shards
require "var"
require "pretty"

### clang
lib LibC
  alias Bool = LibC::Char       # define LibC::Bool as Char
  TRUE  = 1_u8
  FALSE = 0_u8
end
require "./lib_tokyocabinet"
require "./lib_tokyocabinet_const"

## module
module Tokyocabinet
  def self.err(ecode) : LibTokyocabinet::ERR
    LibTokyocabinet::ERR.from_value?(ecode) || LibTokyocabinet::ERR::TCEMISC
  end
end

### library
require "./tokyocabinet/error"
require "./tokyocabinet/core"
require "./tokyocabinet/**"
