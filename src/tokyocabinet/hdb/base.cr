class Tokyocabinet::HDB
  include Core

  delegate build_error, to: self.class
  
  var ptr : LibTokyocabinet::Tchdb* # also used as opened flag

  getter path
  getter mode
  getter clue
  
  def initialize(@path : String, @mode : Mode, clue : String? = nil)
    @clue = clue || @path
  end

  def self.new(path : String, mode : String = "r", clue : String? = nil)
    new(path, Mode.build(mode), clue)
  end
  
  private def db
    @ptr || raise IO::Error.new("The file is not opened: #{@clue}")
  end

  private macro assert_opened
    db
  end

  private macro assert_closed
    raise ThreadingError.new(LibTokyocabinet::ERR::TCETHREAD, "The file is already opened and is locked", @clue) if opened?
  end

  def self.build_error(db : LibTokyocabinet::Tchdb*, message : String? = nil, glue : String? = nil) : Tokyocabinet::Error
    ecode = LibTokyocabinet.tchdbecode(db)
    message ||= String.new(LibTokyocabinet.tchdberrmsg(ecode))
    return Tokyocabinet::Error.build(ecode, message, glue)
  end

  protected def build_error(message : String? = nil, glue : String? = nil)
    assert_opened    
    self.class.build_error(db, message, glue)
  end
end
