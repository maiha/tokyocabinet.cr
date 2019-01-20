lib LibTokyocabinet
  ######################################################################
  ### misc

  fun _tc_dummyfunc : LibC::Int
  fun _tc_dummyfuncv(a : LibC::Int, ...) : LibC::Int
  fun _tc_recencode(ptr : Void*, size : LibC::Int, sp : LibC::Int*, op : Void*) : Void*
  fun _tc_recdecode(ptr : Void*, size : LibC::Int, sp : LibC::Int*, op : Void*) : Void*
end
