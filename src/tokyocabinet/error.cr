module Tokyocabinet
  class Error < Exception
    property message
    var glue : String

    def initialize(@err : LibTokyocabinet::ERR, @message : String)
    end

    def message
      if glue?
        "#{@message}: #{glue}"
      else
        @message
      end
    end
  end

  # Code generation
  # ```crystal
  # errors = File.read_lines("doc/api/error.tsv").map(&.split(/\t/))
  # errors.each do |(name, klass)|
  #   puts "  class %-20s < Error; end    # %s" % [klass, name]
  # end
  # ```
  class Success              < Error; end    # TCESUCCESS
  class ThreadingError       < Error; end    # TCETHREAD
  class InvalidOperation     < Error; end    # TCEINVALID
  class FileNotFound         < Error; end    # TCENOFILE
  class NoPermission         < Error; end    # TCENOPERM
  class InvalidMetaData      < Error; end    # TCEMETA
  class InvalidRecordHeader  < Error; end    # TCERHEAD
  class OpenError            < Error; end    # TCEOPEN
  class CloseError           < Error; end    # TCECLOSE
  class TruncError           < Error; end    # TCETRUNC
  class SyncError            < Error; end    # TCESYNC
  class StatError            < Error; end    # TCESTAT
  class SeekError            < Error; end    # TCESEEK
  class ReadError            < Error; end    # TCEREAD
  class WriteError           < Error; end    # TCEWRITE
  class MmapError            < Error; end    # TCEMMAP
  class LockError            < Error; end    # TCELOCK
  class UnlinkError          < Error; end    # TCEUNLINK
  class RenameError          < Error; end    # TCERENAME
  class MkdirError           < Error; end    # TCEMKDIR
  class RmdirError           < Error; end    # TCERMDIR
  class ExistingRecord       < Error; end    # TCEKEEP
  class NoRecordFound        < Error; end    # TCENOREC
  class MiscellaneousError   < Error; end    # TCEMISC

  # Custom Errors
  class RecordNotFound < Error
    def initialize(message : String)
      super(LibTokyocabinet::ERR::TCEMISC, message)
    end
  end
  
  # Code generation
  # ```crystal
  # errors = File.read_lines("doc/api/error.tsv").map(&.split(/\t/))
  # errors.each do |(name, klass)|
  #   puts "    when LibTokyocabinet::ERR::%-10s ; %s.new(err, msg)" % [name, klass]
  # end
  # ```
  def Error.build(ecode : Int32, msg) : Error
    err = LibTokyocabinet::ERR.from_value?(ecode) || LibTokyocabinet::ERR::TCEMISC
    case err
    when LibTokyocabinet::ERR::TCESUCCESS ; Success.new(err, msg)
    when LibTokyocabinet::ERR::TCETHREAD  ; ThreadingError.new(err, msg)
    when LibTokyocabinet::ERR::TCEINVALID ; InvalidOperation.new(err, msg)
    when LibTokyocabinet::ERR::TCENOFILE  ; FileNotFound.new(err, msg)
    when LibTokyocabinet::ERR::TCENOPERM  ; NoPermission.new(err, msg)
    when LibTokyocabinet::ERR::TCEMETA    ; InvalidMetaData.new(err, msg)
    when LibTokyocabinet::ERR::TCERHEAD   ; InvalidRecordHeader.new(err, msg)
    when LibTokyocabinet::ERR::TCEOPEN    ; OpenError.new(err, msg)
    when LibTokyocabinet::ERR::TCECLOSE   ; CloseError.new(err, msg)
    when LibTokyocabinet::ERR::TCETRUNC   ; TruncError.new(err, msg)
    when LibTokyocabinet::ERR::TCESYNC    ; SyncError.new(err, msg)
    when LibTokyocabinet::ERR::TCESTAT    ; StatError.new(err, msg)
    when LibTokyocabinet::ERR::TCESEEK    ; SeekError.new(err, msg)
    when LibTokyocabinet::ERR::TCEREAD    ; ReadError.new(err, msg)
    when LibTokyocabinet::ERR::TCEWRITE   ; WriteError.new(err, msg)
    when LibTokyocabinet::ERR::TCEMMAP    ; MmapError.new(err, msg)
    when LibTokyocabinet::ERR::TCELOCK    ; LockError.new(err, msg)
    when LibTokyocabinet::ERR::TCEUNLINK  ; UnlinkError.new(err, msg)
    when LibTokyocabinet::ERR::TCERENAME  ; RenameError.new(err, msg)
    when LibTokyocabinet::ERR::TCEMKDIR   ; MkdirError.new(err, msg)
    when LibTokyocabinet::ERR::TCERMDIR   ; RmdirError.new(err, msg)
    when LibTokyocabinet::ERR::TCEKEEP    ; ExistingRecord.new(err, msg)
    when LibTokyocabinet::ERR::TCENOREC   ; NoRecordFound.new(err, msg)
    when LibTokyocabinet::ERR::TCEMISC    ; MiscellaneousError.new(err, msg)
    else                                  ; Error.new(err, msg)
    end
  end
end
