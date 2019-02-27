# Tokyocabinet::HDB
```crystal
  def open : HDB
  def opened?
  def closed?
  def lock : HDB
  def unlock : HDB
  def close : HDB
  def get?(key : String) : String?
  def get(key : String) : String
  def set(key : String, val : String)
  def set(records : Hash(String, String))
  def bget?(key : String) : Bytes?
  def bget(key : String) : Bytes
  def set(key : String, val : Bytes)
  def del(key : String) : Bool
  def count : Int64
  def bnum : Int64
  def each : Nil
  def self.create(path : String, bnum : Int64 = 131071, apow : Int8 = 4, fpow : Int8 = 10, opts : Opts = :none, force : Bool = false)
  def self.open(path : String, mode : (Mode | String)? = nil) : HDB
  def self.open(path : String, mode : (Mode | String)? = nil, &block : HDB -> _ )
  def self.[](path : String, mode : (Mode | String)? = nil) : HDB
```
