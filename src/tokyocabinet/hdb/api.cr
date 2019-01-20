class Tokyocabinet::HDB
  def close
    tchdbclose(hdb)
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
    get?(key) || raise RecordNotFound.new("not found: '#{key}'")
  end
  
  def set(key : String, val : String)
    tchdbput2(hdb, key, val)
  rescue err : InvalidOperation
    raise IO::Error.new("File not open for writing: #{@clue}")
  end

  def del(key : String) : Bool
    tchdbout2(hdb, key)
    return true
  rescue err
    return false if err.message =~ /no record/
    raise err
  end

  def count : Int64
    tchdbrnum(hdb).to_i64
  end

  def bnum : Int64
    tchdbbnum(hdb).to_i64
  end

#  throws tchdbadddouble
#  throws tchdbaddint
#  throws tchdbalign
  proxy  tchdbbnum
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
  proxy  tchdbrnum
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
  throws tchdbtune
#  throws tchdbtype
#  throws tchdbvanish
#  throws tchdbvsiz
#  throws tchdbvsiz2
#  throws tchdbxmsiz
end

class Tokyocabinet::HDB
  def self.create(path : String, bnum : Int64 = 131071, apow : Int8 = 4, fpow : Int8 = 10, opts : Opts = :none, truncate : Bool = true)
    hdb = LibTokyocabinet.tchdbnew

    if LibTokyocabinet.tchdbtune(hdb, bnum, apow, fpow, opts.value) == LibC::FALSE
      raise_error(hdb, "tuning parameters should be set before the database is opened")
    end

    mode = Mode::WRITE | Mode::CREATE
    mode |= Mode::TRUNCATE if truncate
    open(hdb, path, mode).close
  end

  private def self.open(hdb : LibTokyocabinet::Tchdb*, path : String, mode : Mode) : HDB
    File.delete(path) if mode.truncate? && File.exists?(path)
    Dir.mkdir_p(File.dirname(path)) if mode.write? || mode.create?

    if LibTokyocabinet.tchdbopen(hdb, path, mode) == LibC::TRUE
      return new(hdb, clue: path)
    else
      raise_error(hdb, glue: "'#{path}' (#{mode})")
    end
  rescue err : ThreadingError
    err.message = "The file is already opened and is locked"
    raise err
  end

  def self.open(path : String, mode : Mode | String = "r") : HDB
    open(LibTokyocabinet.tchdbnew, path, Mode.build(mode))
  end

  def self.open(path : String, mode : Mode | String = "r", &block : HDB -> _ )
    block.call(hdb = open(path, mode))
  ensure
    hdb.try(&.close)
  end
end
