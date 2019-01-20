class Tokyocabinet::HDB
  include Core

  def initialize(@hdb : LibTokyocabinet::Tchdb*, @clue : String)
  end

  private def hdb
    # TODO: raise error after closed
    @hdb
  end

  private def raise_error
    self.class.raise_error(hdb)
  end

  protected def self.raise_error(hdb : LibTokyocabinet::Tchdb*, message : String? = nil, glue : String? = nil)
    ecode = LibTokyocabinet.tchdbecode(hdb)
    message ||= String.new(LibTokyocabinet.tchdberrmsg(ecode))
    raise Tokyocabinet::Error.build(ecode, message, glue)
  end
end
