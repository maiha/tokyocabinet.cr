lib LibTokyocabinet
  ######################################################################
  ### tcutil.h

  TC_VERSION   = "1.4.48"
  TC_LIBVER    = 911
  TC_FORMATVER = "1.0"

  # enumeration for UCS normalization
  TCUNSPACE = 1 << 0                     # white space normalization
  TCUNLOWER = 1 << 1                     # lower case normalization
  TCUNNOACC = 1 << 2                     # strip accent marks
  TCUNWIDTH = 1 << 3                     # half-width normalization

  # enumeration for KWIC generator
  TCKWMUTAB  = 1 << 0                    # mark up by tabs
  TCKWMUCTRL = 1 << 1                    # mark up by control characters
  TCKWMUBRCT = 1 << 2                    # mark up by brackets
  TCKWNOOVER = 1 << 24                   # no overlap
  TCKWPULEAD = 1 << 25                   # pick up the lead string

  # enumeration for error codes
  enum ERR
    TCESUCCESS                             # success
    TCETHREAD                              # threading error
    TCEINVALID                             # invalid operation
    TCENOFILE                              # file not found
    TCENOPERM                              # no permission
    TCEMETA                                # invalid meta data
    TCERHEAD                               # invalid record header
    TCEOPEN                                # open error
    TCECLOSE                               # close error
    TCETRUNC                               # trunc error
    TCESYNC                                # sync error
    TCESTAT                                # stat error
    TCESEEK                                # seek error
    TCEREAD                                # read error
    TCEWRITE                               # write error
    TCEMMAP                                # mmap error
    TCELOCK                                # lock error
    TCEUNLINK                              # unlink error
    TCERENAME                              # rename error
    TCEMKDIR                               # mkdir error
    TCERMDIR                               # rmdir error
    TCEKEEP                                # existing record
    TCENOREC                               # no record found
    TCEMISC = 9999                         # miscellaneous error
  end

  # enumeration for database type
  enum DB_TYPE
    TCDBTHASH                              # hash table
    TCDBTBTREE                             # B+ tree
    TCDBTFIXED                             # fixed-length
    TCDBTTABLE                             # table
  end

  ######################################################################
  ### tchdb.h

  # enumeration for additional flags
  HDBFOPEN  = 1 << 0 # whether opened
  HDBFFATAL = 1 << 1 # whether with fatal error

  # enumeration for tuning options
  HDBTLARGE   = 1 << 0 # use 64-bit bucket array
  HDBTDEFLATE = 1 << 1 # compress each record with Deflate
  HDBTBZIP    = 1 << 2 # compress each record with BZIP2
  HDBTTCBS    = 1 << 3 # compress each record with TCBS
  HDBTEXCODEC = 1 << 4 # compress each record with custom functions

  # enumeration for open modes
  HDBOREADER = 1 << 0 # open as a reader
  HDBOWRITER = 1 << 1 # open as a writer
  HDBOCREAT  = 1 << 2 # writer creating
  HDBOTRUNC  = 1 << 3 # writer truncating
  HDBONOLCK  = 1 << 4 # open without locking
  HDBOLCKNB  = 1 << 5 # lock without blocking
  HDBOTSYNC  = 1 << 6 # synchronize every transaction

end
