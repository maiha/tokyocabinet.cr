class Tokyocabinet::HDB
  @[Flags]
  enum Opts
    LARGE   = LibTokyocabinet::HDBTLARGE
    DEFLATE = LibTokyocabinet::HDBTDEFLATE
    BZIP    = LibTokyocabinet::HDBTBZIP
    TCBS    = LibTokyocabinet::HDBTTCBS
    EXCODEC = LibTokyocabinet::HDBTEXCODEC
  end
end
