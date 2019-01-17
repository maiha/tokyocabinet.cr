module Tokyocabinet::Core
  macro throws(op)
    macro {{op.id}}(*args)
      if LibTokyocabinet.{{op.id}}(\{{*args}}) == LibC::TRUE
      else
        raise error_message
      end
    end
  end

  macro proxy(op)
    macro {{op.id}}(*args)
      LibTokyocabinet.{{op.id}}(\{{*args}})
    end
  end
end
