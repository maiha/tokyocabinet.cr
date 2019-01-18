module Tokyocabinet
  class Error < Exception
    getter err
    property message
    def initialize(@err : LibTokyocabinet::ERR, @message : String)
    end
  end

  # TCESUCCESS                             # success
  class Success < Error
  end

#    TCETHREAD                              # threading error
  #    TCEINVALID                             # invalid operation
  class InvalidOperation < Error
  end
  
#    TCENOFILE                              # file not found
#    TCENOPERM                              # no permission

  #    TCEMETA                                # invalid meta data
  class InvalidMetaData < Error
  end

#    TCERHEAD                               # invalid record header
#    TCEOPEN                                # open error
#    TCECLOSE                               # close error
#    TCETRUNC                               # trunc error
#    TCESYNC                                # sync error
#    TCESTAT                                # stat error
#    TCESEEK                                # seek error
#    TCEREAD                                # read error
#    TCEWRITE                               # write error
#    TCEMMAP                                # mmap error
#    TCELOCK                                # lock error
#    TCEUNLINK                              # unlink error
#    TCERENAME                              # rename error
#    TCEMKDIR                               # mkdir error
#    TCERMDIR                               # rmdir error
#    TCEKEEP                                # existing record
#    TCENOREC                               # no record found
#    TCEMISC = 9999                         # miscellaneous error

  def Error.build(ecode, msg) : Error
    err = LibTokyocabinet::ERR.from_value?(ecode) || LibTokyocabinet::ERR::TCEMISC
    case err
    when .tceinvalid? ; InvalidOperation.new(err, msg)
    else ; Error.new(err, msg)
    end
  end
end
