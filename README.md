# tokyocabinet [![Build Status](https://travis-ci.org/maiha/tokyocabinet.cr.svg?branch=master)](https://travis-ci.org/maiha/tokyocabinet.cr)

TokyoCabinet client for [Crystal](http://crystal-lang.org/).
- crystal: 0.27.0

## Usage

```crystal
require "tokyocabinet"

hdb = Tokyocabinet::HDB.open("test.tch", "w+") # mode: "r", "w", "w+"
hdb.set("foo", "abc")
hdb.get("foo")  # => "abc"
hdb.get?("foo") # => "abc"
hdb.get?("xxx") # => nil
hdb.get("xxx")  # raises "not found"
hdb.del("foo")  # => true
hdb.del("foo")  # => false
hdb.get?("foo") # => nil
hdb.count       # => 0
hdb.close
```

## Supported API

- [Tokyocabinet::HDB](./doc/api/HDB.md)
- [LibTokyocabinet](./doc/api/API.md)

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
    version: 0.1.0
```
2. Run `shards install`

## Development

```console
$ make spec
```

## Contributing

1. Fork it (<https://github.com/maiha/tokyocabinet.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [maiha](https://github.com/maiha) - creator and maintainer
