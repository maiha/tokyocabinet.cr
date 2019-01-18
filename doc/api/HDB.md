# Tokyocabinet::HDB
```crystal
  def self.open(path : String, mode : Omode | String = "r") : HDB
  def close
  def get?(key : String) : String?
  def get(key : String) : String
  def set(key : String, val : String)
  def del(key : String) : Bool
  def count : Int64
```
