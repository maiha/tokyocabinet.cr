class Tokyocabinet::HDB
  def open : HDB
    return self if opened?

    File.delete(@path) if @mode.truncate? && File.exists?(@path)
    Dir.mkdir_p(File.dirname(@path)) if @mode.write? || @mode.create?

    ptr = LibTokyocabinet.tchdbnew

    if LibTokyocabinet.tchdbopen(ptr, @path, @mode) == LibC::TRUE
      self.ptr = ptr
      return self
    else
      raise build_error(ptr, glue: "'#{@path}' (#{@mode})")
    end

    return self
  rescue err : ThreadingError
    err.message = "The file is already opened and is locked"
    raise err
  end

  def opened?
    !!@ptr
  end

  def lock : HDB
    open
  end

  def unlock : HDB
    close
  end

  def close : HDB
    if opened?
      tchdbclose
      @ptr = nil
    end
    return self
  end

  def get?(key : String) : String?
    ptr = tchdbget2(key)
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
    tchdbput2(key, val)
  rescue err : InvalidOperation
    raise IO::Error.new("File not open for writing: #{@clue}")
  end

  def del(key : String) : Bool
    tchdbout2(key)
    return true
  rescue err
    return false if err.message =~ /no record/
    raise err
  end

  def count : Int64
    tchdbrnum.to_i64
  end

  def bnum : Int64
    tchdbbnum.to_i64
  end

#  throws tchdbadddouble
#  throws tchdbaddint
#  throws tchdbalign
  native tchdbbnum
#  throws tchdbbnumused
#  throws tchdbcacheclear
  throws tchdbclose
#  throws tchdbcodecfunc
#  throws tchdbcopy
#  throws tchdbdbgfd
#  throws tchdbdefrag
#  throws tchdbdel
#  throws tchdbdfunit
  native tchdbecode
  native tchdberrmsg
#  throws tchdbfbpmax
#  throws tchdbflags
#  throws tchdbforeach
#  throws tchdbfsiz
#  throws tchdbfwmkeys
#  throws tchdbfwmkeys2
#  throws tchdbget
  native tchdbget2
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
  native tchdbrnum
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
  def self.create(path : String, bnum : Int64 = 131071, apow : Int8 = 4, fpow : Int8 = 10, opts : Opts = :none, force : Bool = false)
    ptr = LibTokyocabinet.tchdbnew

    if LibTokyocabinet.tchdbtune(ptr, bnum, apow, fpow, opts) == LibC::FALSE
      error = build_error(ptr, "tuning parameters should be set before the database is opened")
      raise error
    end

    File.delete(path) if force && File.exists?(path)
    Dir.mkdir_p(File.dirname(path))

    mode = Mode::WRITE | Mode::CREATE
    if LibTokyocabinet.tchdbopen(ptr, path, mode) == LibC::FALSE
      raise build_error(ptr, glue: "'#{path}' (#{mode})")
    end
    hdb = new(path, mode)
    hdb.ptr = ptr

    return hdb.close
  end

  def self.open(path : String, mode : (Mode | String)? = nil) : HDB
    new(path, mode).lock
  end

  def self.open(path : String, mode : (Mode | String)? = nil, &block : HDB -> _ )
    block.call(hdb = open(path, mode))
  ensure
    hdb.try(&.close)
  end

  def self.[](path : String, mode : (Mode | String)? = nil) : HDB
    new(path, mode)
  end
end
