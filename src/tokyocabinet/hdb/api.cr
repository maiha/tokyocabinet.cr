class Tokyocabinet::HDB
  include Enumerable(String)

  def open : HDB
    return self if opened?
    open(Lib.tchdbnew)
  end

  protected def open(ptr) : HDB
    File.delete(@path) if @mode.truncate? && File.exists?(@path)
    Dir.mkdir_p(File.dirname(@path)) if @mode.write? || @mode.create?

    if Lib.tchdbopen(ptr, @path, @mode) == LibC::TRUE
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

  def closed?
    !@ptr
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
      tchdbdel
      @ptr = nil
    end
    return self
  end

  ### String
  
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

  def set(records : Hash(String, String))
    connect do
      records.each do |key, val|
        Lib.tchdbput2(db, key, val)
      end
    end
  rescue err : InvalidOperation
    raise IO::Error.new("File not open for writing: #{@clue}")
  end

  ### Binary

  def bget?(key : String) : Bytes?
    len = Pointer(Int32).malloc(1_u64)
    ptr = tchdbget(key, key.size, len).as(Pointer(UInt8))
    if ptr.null?
      return nil
    else
      return Bytes.new(ptr, len.value)
    end
  end
  
  def bget(key : String) : Bytes
    bget?(key) || raise RecordNotFound.new("not found: '#{key}'")
  end
  
  def set(key : String, val : Bytes)
    tchdbput(key.to_unsafe, key.size, val.to_unsafe, val.size)
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

  def each : Nil
    connect do
      iternew
      while key = iternext?
        yield key
      end
    end
  end

  private def iternew
    # setcodecfunc # TODO: enable this to support HDBTEXCODEC
    tchdbiterinit
  end

  private def iternext? : String?
    kbuf = Lib.tchdbiternext2(db)
    if kbuf.null?
      return nil
    else
      return String.new(kbuf).tap{ Lib.tcfree(kbuf) }
    end
  end

  private def setcodecfunc
    close
    ptr = Lib.tchdbnew
    if Lib.tchdbsetcodecfunc(
         ptr,
         ->(_ptr, size, sp, op) {
           Lib._tc_recencode(_ptr, size, sp, op)
           Pointer(Void).null
         },
         Pointer(Void).null,
         ->(_ptr, size, sp, op) {
             Lib._tc_recdecode(_ptr, size, sp, op)
             Pointer(Void).null
         },
         Pointer(Void).null
       ) == LibC::TRUE
      open(ptr)
    else
      raise self.class.build_error(ptr)
    end
  rescue err : InvalidOperation
    err.message = "tchdbsetcodecfunc was called with opened database"
    raise err
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
  native tchdbdel
#  throws tchdbdfunit
  native tchdbecode
  native tchdberrmsg
#  throws tchdbfbpmax
#  throws tchdbflags
#  throws tchdbforeach
#  throws tchdbfsiz
#  throws tchdbfwmkeys
#  throws tchdbfwmkeys2
  native tchdbget
  native tchdbget2
#  throws tchdbget3
#  throws tchdbgetnext
#  throws tchdbgetnext2
#  throws tchdbgetnext3
#  throws tchdbhasmutex
#  throws tchdbinode
  throws tchdbiterinit
#  throws tchdbiterinit2
#  throws tchdbiterinit3
  native tchdbiternext
  native tchdbiternext2
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
  throws tchdbput
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
  throws tchdbsetcodecfunc
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
    ptr = Lib.tchdbnew

    if Lib.tchdbtune(ptr, bnum, apow, fpow, opts) == LibC::FALSE
      error = build_error(ptr, "tuning parameters should be set before the database is opened")
      raise error
    end

    File.delete(path) if force && File.exists?(path)
    Dir.mkdir_p(File.dirname(path))

    mode = Mode::WRITE | Mode::CREATE
    if Lib.tchdbopen(ptr, path, mode) == LibC::FALSE
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
