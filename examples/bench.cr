# ```console
# $ crystal build -o bench-cr examples/bench.cr --release
#
# $ time ./bench-cr 10_000_000 test.tch
# ./bench-cr 10_000_000 test.tch  4.69s user 14.47s system 103% cpu 18.459 total
#
# $ tchmgr inform test.tch | grep record
# record number: 10000000
#
# $ grep 'model name' /proc/cpuinfo
# model name      : Intel(R) Core(TM) i7-7700HQ CPU @ 2.80GHz
# ```

require "../src/tokyocabinet"

include Tokyocabinet

def usage
  abort <<-EOF
    usage: #{PROGRAM_NAME} count path
      count : the number of record
      path  : the file path of tch
    EOF
end

limit = ARGV.shift?.try(&.delete("_").to_i) || usage
path  = ARGV.shift? || usage

HDB.create(path, bnum: limit.to_i64, force: true)
HDB.open(path) do |hdb|
  (1..limit).each do |i|
    hdb.set(i.to_s, i.to_s)
  end
end
