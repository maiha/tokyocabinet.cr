module Tokyocabinet::Core(T)
  abstract def db : T
  abstract def opened? : Bool
  abstract def open : T
  abstract def close : T
  abstract def unlock : T

  alias Lib = LibTokyocabinet
                                         
  def connect(&block : T -> _)
    should_close = !opened?
    open
    yield(self)
  ensure
    close if should_close
  end

  protected def unlock(&block : T -> _)
    should_lock = opened?
    unlock
    yield(self)
  ensure
    lock if should_lock
  end

  # proxy to native command with error handlings
  macro throws(op)
    macro _{{op.id}}(*args)
      if LibTokyocabinet.{{op.id}}(db, \{{*args}}) == LibC::TRUE
      else
        raise build_error
      end
    end

    macro {{op.id}}(*args)
      connect{ _{{op.id}}(\{{*args}}) }
    end
  end

  # proxy to native command
  macro native(op)
    macro _{{op.id}}(*args)
      LibTokyocabinet.{{op.id}}(db, \{{*args}})
    end

    macro {{op.id}}(*args)
      connect{ _{{op.id}}(\{{*args}}) }
    end
  end
end
