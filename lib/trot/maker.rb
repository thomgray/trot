module Trot
  class Make
    class << self
      def should_update_target(src_files, target)
        if src_files.class == String
          should_update_target_multiple_src([src_files], target)
        else
          should_update_target_multiple_src(src_files, target)
        end
      end
      
      private

      def should_update_target_multiple_src(src_files, target)
        return true unless File.exist? target
        src_files.each do |src_file|
          return true if File.mtime(src_file) > File.mtime(target)
        end
        false
      end
    end
  end
end