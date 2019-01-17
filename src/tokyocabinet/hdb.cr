class Tokyocabinet::HDB
  include Core

  @[Flags]
  enum Omode
    READER = LibTokyocabinet::HDBOREADER
    WRITER = LibTokyocabinet::HDBOWRITER
    CREATE = LibTokyocabinet::HDBOCREAT
  end

  def self.open(path : String, mode : (Omode | String)? = nil) : HDB
    omode = self.omode(mode)
    if omode.writer? || omode.create?
      Dir.mkdir_p(File.dirname(path))
    end

    ptr = LibTokyocabinet.tchdbnew
    if LibTokyocabinet.tchdbopen(ptr, path, omode) == LibC::TRUE
      return new(ptr)
    else
      raise Errno.new("Error opening file '#{path}' with mode '#{omode}'")
    end
  end

  def self.omode(v : Omode | String | Nil) : Omode
    case v
    when Omode    ; v
    when nil, "r" ; Omode::READER
    when "w"      ; Omode::WRITER
    when "w+"     ; Omode::CREATE | Omode::WRITER
    else          ; raise "Unknown open mode: '#{v}'"
    end
  end
end

class Tokyocabinet::HDB
  def initialize(@hdb : LibTokyocabinet::Tchdb*)
  end

  private def hdb
    # TODO: raise error after closed
    @hdb
  end

  def close
    tchdbclose(hdb)
  end
  
  def error_message : String
    ecode = tchdbecode(hdb)
    ptr = tchdberrmsg(ecode)
    return String.new(ptr)
  end

  def get?(key : String) : String?
    ptr = tchdbget2(hdb, key)
    if ptr.null?
      return nil
    else
      return String.new(ptr)
    end
  end
  
  def get(key : String) : String
    get?(key) || raise "not found: '#{key}'"
  end
  
  def set(key : String, val : String)
    tchdbput2(hdb, key, val)
  end

  def del(key : String) : Bool
    tchdbout2(hdb, key)
    return true
  rescue err
    return false if err.message =~ /no record/
    raise err
  end
  
#  throws tchdbadddouble
#  throws tchdbaddint
#  throws tchdbalign
#  throws tchdbbnum
#  throws tchdbbnumused
#  throws tchdbcacheclear
  throws tchdbclose
#  throws tchdbcodecfunc
#  throws tchdbcopy
#  throws tchdbdbgfd
#  throws tchdbdefrag
#  throws tchdbdel
#  throws tchdbdfunit
  proxy  tchdbecode
  proxy  tchdberrmsg
#  throws tchdbfbpmax
#  throws tchdbflags
#  throws tchdbforeach
#  throws tchdbfsiz
#  throws tchdbfwmkeys
#  throws tchdbfwmkeys2
#  throws tchdbget
  proxy  tchdbget2
#  throws tchdbget3
#  throws tchdbgetnext
#  throws tchdbgetnext2
#  throws tchdbgetnext3
#  throws tchdbhasmutex
#  throws tchdbinode
#  throws tchdbiterinit
#  throws tchdbiterinit2
#  throws tchdbiterinit3
#  throws tchdbiternext
#  throws tchdbiternext2
#  throws tchdbiternext3
#  throws tchdbmemsync
#  throws tchdbmtime
#  throws tchdbnew
#  throws tchdbomode
#  throws tchdbopaque
#  throws tchdbopen
#  throws tchdboptimize
#  throws tchdbopts
#  throws tchdbout
  throws tchdbout2
#  throws tchdbpath
#  throws tchdbput
  throws tchdbput2
#  throws tchdbputasync
#  throws tchdbputasync2
#  throws tchdbputcat
#  throws tchdbputcat2
#  throws tchdbputkeep
#  throws tchdbputkeep2
#  throws tchdbputproc
#  throws tchdbrnum
#  throws tchdbsetcache
#  throws tchdbsetcodecfunc
#  throws tchdbsetdbgfd
#  throws tchdbsetdfunit
#  throws tchdbsetecode
#  throws tchdbsetmutex
#  throws tchdbsettype
#  throws tchdbsetxmsiz
#  throws tchdbsync
#  throws tchdbtranabort
#  throws tchdbtranbegin
#  throws tchdbtrancommit
#  throws tchdbtranvoid
#  throws tchdbtune
#  throws tchdbtype
#  throws tchdbvanish
#  throws tchdbvsiz
#  throws tchdbvsiz2
#  throws tchdbxmsiz
end
