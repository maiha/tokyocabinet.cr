module Tokyocabinet::Core(T)
  abstract def db : T

  alias Lib = LibTokyocabinet
                                         
  def connect(&block : -> _)
    if opened?
      yield
    else
      open
      yield.tap{ close }
    end
  end

  protected def unlock(&block : -> _)
    should_lock = opened?
    unlock
    yield
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
