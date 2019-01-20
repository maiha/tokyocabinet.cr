# tokyocabinet [![Build Status](https://travis-ci.org/maiha/tokyocabinet.cr.svg?branch=master)](https://travis-ci.org/maiha/tokyocabinet.cr)

TokyoCabinet client for [Crystal](http://crystal-lang.org/).
- crystal: 0.27.0

## Usage

```crystal
require "tokyocabinet"

include Tokyocabinet
hdb = HDB.open("test.tch", mode: "w+")
# See `Tokyocabinet::HDB::Mode` for available modes

hdb.set("foo", "abc")
hdb.count       # => 1
hdb.get("foo")  # => "abc"
hdb.get?("foo") # => "abc"
hdb.get?("xxx") # => nil
hdb.get("xxx")  # raises RecordNotFound
hdb.del("foo")  # => true
hdb.del("foo")  # => false
hdb.get?("foo") # => nil

hdb.close
```

### locks

By default, TokyoCabinet locks db files that run on the same thread.
The `unlock` method provides dynamic locking at command execution.
Although this avoids deadlock, execution speed is slow and resource consumption is increased.

```crystal
a = HDB.open("test.tch")      # locked by a
b = HDB.open("test.tch", "r") # raises ThreadingError (even if readonly)
a.unlock                      # free
b = HDB.open("test.tch")      # locked by b
b.unlock                      # free
a.set("foo", "1")             # locked and unlocked automatically
b.set("bar", "2")             # locked and unlocked automatically
```

Note that `.new` is same as `.[]` and `.open.unlock`.
So all following codes work same.

```crystal
HDB.new("test.tch")
HDB.new("test.tch", "w+")
HDB["test.tch"]
HDB["test.tch", "w+"]
HDB.open("test.tch").unlock
```

### tuning

```crystal
HDB.create("a.tch", bnum: 13)              # creates db with bnum=13
HDB.create("a.tch", bnum: 17)              # skips (already exists)
HDB.create("a.tch", bnum: 17, force: true) # recreates db with bnum=17
```

## Supported API

- [Tokyocabinet::HDB](./doc/api/HDB.md)
  - [Mode](./src/tokyocabinet/hdb/mode.cr)
- [LibTokyocabinet](./doc/api/API.md)

## Benchmark

- Intel(R) Core(TM) i7-7700HQ CPU @ 2.80GHz

### set 10_000_000 records

| LANG    | sec    | code |
----------|--------|-------
| C       | 17.647 | [examples/bench.c](examples/bench.c)   |
| Crystal | 18.459 | [examples/bench.cr](examples/bench.cr) |

## Prerequisites

### libtokyocabinet

On ubuntu
```console
$ apt install libtokyocabinet-dev
```

### shard.yml

1. Add the dependency to your `shard.yml`:
```yaml
dependencies:
  tokyocabinet:
    github: maiha/tokyocabinet.cr
    version: 0.2.0
```
2. Run `shards install`

## Development

```console
$ crystal spec -v
```

### Run test in docker

```console
$ make spec
```

### Generate documents

```console
$ make docs
```

## Contributing

1. Fork it (<https://github.com/maiha/tokyocabinet.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [maiha](https://github.com/maiha) - creator and maintainer
