# Tokyocabinet::HDB
```crystal
  def close
  def get?(key : String) : String?
  def get(key : String) : String
  def set(key : String, val : String)
  def del(key : String) : Bool
  def count : Int64
  def bnum : Int64
  def self.create(path : String, bnum : Int64 = 131071, apow : Int8 = 4, fpow : Int8 = 10, opts : Opts = :none, truncate : Bool = true)
  def self.open(path : String, mode : Mode | String = "r") : HDB
  def self.open(path : String, mode : Mode | String = "r", &block : HDB -> _ )
```
