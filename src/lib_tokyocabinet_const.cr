lib LibTokyocabinet
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
