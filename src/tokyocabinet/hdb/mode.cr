class Tokyocabinet::HDB
  MODE_MAP = {
    'r' => Mode::READ,
    'w' => Mode::WRITE,
    '+' => Mode::CREATE,
    't' => Mode::TRUNCATE,
    'e' => Mode::NOLOCK,
    'f' => Mode::NONBLOCK,
    's' => Mode::SYNC,
  }

  @[Flags]
  enum Mode
    READ     = LibTokyocabinet::HDBOREADER # "r"
    WRITE    = LibTokyocabinet::HDBOWRITER # "w"
    CREATE   = LibTokyocabinet::HDBOCREAT  # "+"
    TRUNCATE = LibTokyocabinet::HDBOTRUNC  # "t"
    NOLOCK   = LibTokyocabinet::HDBONOLCK  # "e"
    NONBLOCK = LibTokyocabinet::HDBOLCKNB  # "f"
    SYNC     = LibTokyocabinet::HDBOTSYNC  # "s"

    def self.build(value : Mode | String | Nil) : Mode
      case value
      when Mode
        return value
      when Nil
        return READ
      when String
        mode = None
        value.each_char {|char| mode |= MODE_MAP[char]? || raise char.to_s}
        return mode
      else
        raise value.inspect
      end
    rescue err
      raise IO::Error.new("Unknown open mode: '%s' for %s" % [err.to_s, MODE_MAP.keys.inspect])
    end
  end
end
