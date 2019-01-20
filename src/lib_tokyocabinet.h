@[Include("tchdb.h", prefix: %w(tchdb tcfree), remove_prefix: false)]
@[Link("tokyocabinet")]
lib LibTokyocabinet
end
