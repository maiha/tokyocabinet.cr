@[Link("tokyocabinet")]
lib LibTokyocabinet
  fun tchdberrmsg(ecode : LibC::Int) : LibC::Char*
  fun tchdbnew : Tchdb*
  struct Tchdb
    mmtx : Void*
    rmtxs : Void*
    dmtx : Void*
    wmtx : Void*
    eckey : Void*
    rpath : LibC::Char*
    type : Uint8T
    flags : Uint8T
    bnum : Uint64T
    apow : Uint8T
    fpow : Uint8T
    opts : Uint8T
    path : LibC::Char*
    fd : LibC::Int
    omode : Uint32T
    rnum : Uint64T
    fsiz : Uint64T
    frec : Uint64T
    dfcur : Uint64T
    iter : Uint64T
    map : LibC::Char*
    msiz : Uint64T
    xmsiz : Uint64T
    xfsiz : Uint64T
    ba32 : Uint32T*
    ba64 : Uint64T*
    align : Uint32T
    runit : Uint32T
    zmode : LibC::Bool
    fbpmax : Int32T
    fbpool : Void*
    fbpnum : Int32T
    fbpmis : Int32T
    async : LibC::Bool
    drpool : Tcxstr*
    drpdef : Tcxstr*
    drpoff : Uint64T
    recc : Tcmdb*
    rcnum : Uint32T
    enc : Tccodec
    encop : Void*
    dec : Tccodec
    decop : Void*
    ecode : LibC::Int
    fatal : LibC::Bool
    inode : Uint64T
    mtime : TimeT
    dfunit : Uint32T
    dfcnt : Uint32T
    tran : LibC::Bool
    walfd : LibC::Int
    walend : Uint64T
    dbgfd : LibC::Int
    cnt_writerec : Int64T
    cnt_reuserec : Int64T
    cnt_moverec : Int64T
    cnt_readrec : Int64T
    cnt_searchfbp : Int64T
    cnt_insertfbp : Int64T
    cnt_splicefbp : Int64T
    cnt_dividefbp : Int64T
    cnt_mergefbp : Int64T
    cnt_reducefbp : Int64T
    cnt_appenddrp : Int64T
    cnt_deferdrp : Int64T
    cnt_flushdrp : Int64T
    cnt_adjrecc : Int64T
    cnt_defrag : Int64T
    cnt_shiftrec : Int64T
    cnt_trunc : Int64T
  end
  alias Uint8T = UInt8
  alias Uint64T = LibC::ULong
  alias Uint32T = LibC::UInt
  alias Int32T = LibC::Int
  struct Tcxstr
    ptr : LibC::Char*
    size : LibC::Int
    asize : LibC::Int
  end
  struct Tcmdb
    mmtxs : Void**
    imtx : Void*
    maps : Tcmap**
    iter : LibC::Int
  end
  struct Tcmap
    buckets : Tcmaprec**
    first : Tcmaprec*
    last : Tcmaprec*
    cur : Tcmaprec*
    bnum : Uint32T
    rnum : Uint64T
    msiz : Uint64T
  end
  struct X_Tcmaprec
    ksiz : Int32T
    vsiz : Int32T
    left : X_Tcmaprec*
    right : X_Tcmaprec*
    prev : X_Tcmaprec*
    next : X_Tcmaprec*
  end
  type Tcmaprec = X_Tcmaprec
  alias Tccodec = (Void*, LibC::Int, LibC::Int*, Void* -> Void*)
  alias X__TimeT = LibC::Long
  alias TimeT = X__TimeT
  alias Int64T = LibC::Long
  fun tchdbdel(hdb : Tchdb*)
  fun tchdbecode(hdb : Tchdb*) : LibC::Int
  fun tchdbsetmutex(hdb : Tchdb*) : LibC::Bool
  fun tchdbtune(hdb : Tchdb*, bnum : Int64T, apow : Int8T, fpow : Int8T, opts : Uint8T) : LibC::Bool
  alias Int8T = LibC::Char
  fun tchdbsetcache(hdb : Tchdb*, rcnum : Int32T) : LibC::Bool
  fun tchdbsetxmsiz(hdb : Tchdb*, xmsiz : Int64T) : LibC::Bool
  fun tchdbsetdfunit(hdb : Tchdb*, dfunit : Int32T) : LibC::Bool
  fun tchdbopen(hdb : Tchdb*, path : LibC::Char*, omode : LibC::Int) : LibC::Bool
  fun tchdbclose(hdb : Tchdb*) : LibC::Bool
  fun tchdbput(hdb : Tchdb*, kbuf : Void*, ksiz : LibC::Int, vbuf : Void*, vsiz : LibC::Int) : LibC::Bool
  fun tchdbput2(hdb : Tchdb*, kstr : LibC::Char*, vstr : LibC::Char*) : LibC::Bool
  fun tchdbputkeep(hdb : Tchdb*, kbuf : Void*, ksiz : LibC::Int, vbuf : Void*, vsiz : LibC::Int) : LibC::Bool
  fun tchdbputkeep2(hdb : Tchdb*, kstr : LibC::Char*, vstr : LibC::Char*) : LibC::Bool
  fun tchdbputcat(hdb : Tchdb*, kbuf : Void*, ksiz : LibC::Int, vbuf : Void*, vsiz : LibC::Int) : LibC::Bool
  fun tchdbputcat2(hdb : Tchdb*, kstr : LibC::Char*, vstr : LibC::Char*) : LibC::Bool
  fun tchdbputasync(hdb : Tchdb*, kbuf : Void*, ksiz : LibC::Int, vbuf : Void*, vsiz : LibC::Int) : LibC::Bool
  fun tchdbputasync2(hdb : Tchdb*, kstr : LibC::Char*, vstr : LibC::Char*) : LibC::Bool
  fun tchdbout(hdb : Tchdb*, kbuf : Void*, ksiz : LibC::Int) : LibC::Bool
  fun tchdbout2(hdb : Tchdb*, kstr : LibC::Char*) : LibC::Bool
  fun tchdbget(hdb : Tchdb*, kbuf : Void*, ksiz : LibC::Int, sp : LibC::Int*) : Void*
  fun tchdbget2(hdb : Tchdb*, kstr : LibC::Char*) : LibC::Char*
  fun tchdbget3(hdb : Tchdb*, kbuf : Void*, ksiz : LibC::Int, vbuf : Void*, max : LibC::Int) : LibC::Int
  fun tchdbvsiz(hdb : Tchdb*, kbuf : Void*, ksiz : LibC::Int) : LibC::Int
  fun tchdbvsiz2(hdb : Tchdb*, kstr : LibC::Char*) : LibC::Int
  fun tchdbiterinit(hdb : Tchdb*) : LibC::Bool
  fun tchdbiternext(hdb : Tchdb*, sp : LibC::Int*) : Void*
  fun tchdbiternext2(hdb : Tchdb*) : LibC::Char*
  fun tchdbiternext3(hdb : Tchdb*, kxstr : Tcxstr*, vxstr : Tcxstr*) : LibC::Bool
  fun tchdbfwmkeys(hdb : Tchdb*, pbuf : Void*, psiz : LibC::Int, max : LibC::Int) : Tclist*
  struct Tclist
    array : Tclistdatum*
    anum : LibC::Int
    start : LibC::Int
    num : LibC::Int
  end
  struct Tclistdatum
    ptr : LibC::Char*
    size : LibC::Int
  end
  fun tchdbfwmkeys2(hdb : Tchdb*, pstr : LibC::Char*, max : LibC::Int) : Tclist*
  fun tchdbaddint(hdb : Tchdb*, kbuf : Void*, ksiz : LibC::Int, num : LibC::Int) : LibC::Int
  fun tchdbadddouble(hdb : Tchdb*, kbuf : Void*, ksiz : LibC::Int, num : LibC::Double) : LibC::Double
  fun tchdbsync(hdb : Tchdb*) : LibC::Bool
  fun tchdboptimize(hdb : Tchdb*, bnum : Int64T, apow : Int8T, fpow : Int8T, opts : Uint8T) : LibC::Bool
  fun tchdbvanish(hdb : Tchdb*) : LibC::Bool
  fun tchdbcopy(hdb : Tchdb*, path : LibC::Char*) : LibC::Bool
  fun tchdbtranbegin(hdb : Tchdb*) : LibC::Bool
  fun tchdbtrancommit(hdb : Tchdb*) : LibC::Bool
  fun tchdbtranabort(hdb : Tchdb*) : LibC::Bool
  fun tchdbpath(hdb : Tchdb*) : LibC::Char*
  fun tchdbrnum(hdb : Tchdb*) : Uint64T
  fun tchdbfsiz(hdb : Tchdb*) : Uint64T
  fun tchdbsetecode(hdb : Tchdb*, ecode : LibC::Int, filename : LibC::Char*, line : LibC::Int, func : LibC::Char*)
  fun tchdbsettype(hdb : Tchdb*, type : Uint8T)
  fun tchdbsetdbgfd(hdb : Tchdb*, fd : LibC::Int)
  fun tchdbdbgfd(hdb : Tchdb*) : LibC::Int
  fun tchdbhasmutex(hdb : Tchdb*) : LibC::Bool
  fun tchdbmemsync(hdb : Tchdb*, phys : LibC::Bool) : LibC::Bool
  fun tchdbbnum(hdb : Tchdb*) : Uint64T
  fun tchdbalign(hdb : Tchdb*) : Uint32T
  fun tchdbfbpmax(hdb : Tchdb*) : Uint32T
  fun tchdbxmsiz(hdb : Tchdb*) : Uint64T
  fun tchdbinode(hdb : Tchdb*) : Uint64T
  fun tchdbmtime(hdb : Tchdb*) : TimeT
  fun tchdbomode(hdb : Tchdb*) : LibC::Int
  fun tchdbtype(hdb : Tchdb*) : Uint8T
  fun tchdbflags(hdb : Tchdb*) : Uint8T
  fun tchdbopts(hdb : Tchdb*) : Uint8T
  fun tchdbopaque(hdb : Tchdb*) : LibC::Char*
  fun tchdbbnumused(hdb : Tchdb*) : Uint64T
  fun tchdbsetcodecfunc(hdb : Tchdb*, enc : Tccodec, encop : Void*, dec : Tccodec, decop : Void*) : LibC::Bool
  fun tchdbcodecfunc(hdb : Tchdb*, ep : Tccodec*, eop : Void**, dp : Tccodec*, dop : Void**)
  fun tchdbdfunit(hdb : Tchdb*) : Uint32T
  fun tchdbdefrag(hdb : Tchdb*, step : Int64T) : LibC::Bool
  fun tchdbcacheclear(hdb : Tchdb*) : LibC::Bool
  fun tchdbputproc(hdb : Tchdb*, kbuf : Void*, ksiz : LibC::Int, vbuf : Void*, vsiz : LibC::Int, proc : Tcpdproc, op : Void*) : LibC::Bool
  alias Tcpdproc = (Void*, LibC::Int, LibC::Int*, Void* -> Void*)
  fun tchdbgetnext(hdb : Tchdb*, kbuf : Void*, ksiz : LibC::Int, sp : LibC::Int*) : Void*
  fun tchdbgetnext2(hdb : Tchdb*, kstr : LibC::Char*) : LibC::Char*
  fun tchdbgetnext3(hdb : Tchdb*, kbuf : LibC::Char*, ksiz : LibC::Int, sp : LibC::Int*, vbp : LibC::Char**, vsp : LibC::Int*) : LibC::Char*
  fun tchdbiterinit2(hdb : Tchdb*, kbuf : Void*, ksiz : LibC::Int) : LibC::Bool
  fun tchdbiterinit3(hdb : Tchdb*, kstr : LibC::Char*) : LibC::Bool
  fun tchdbforeach(hdb : Tchdb*, iter : Tciter, op : Void*) : LibC::Bool
  alias Tciter = (Void*, LibC::Int, Void*, LibC::Int, Void* -> LibC::Bool)
  fun tchdbtranvoid(hdb : Tchdb*) : LibC::Bool
end

