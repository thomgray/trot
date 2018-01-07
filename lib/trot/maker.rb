module Trot
  class Make
    class << self
      def should_update_target(src, target)
        return true unless File.exist? target
        return File.mtime(src) > File.mtime(target)
      end
    end
  end
end