require 'fileutils'

module Trot
  class << self
    def absolute_path(path)
      File.join(Dir.pwd, path)
    end
    
    def ensure_dir(dir)
      FileUtils::mkdir_p dir unless Dir.exist? dir
    end
  end
end