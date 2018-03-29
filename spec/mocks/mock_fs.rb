module Trot
  class MockFS
    attr_accessor :base_dir
    attr_accessor :c_files
    attr_accessor :h_files

    def initialize(opts = {})
      @base_dir = opts[:base_dir] || '/foo/bar'
      @c_files = opts[:c_files] || ['main.c', 'foo.c']
      @h_files = opts[:h_files] || ['foo.h']
    end

    def absolute_path(path)
      return path if path.start_with? '/'
      File.join(@base_dir, path)
    end

    def ensure_dir(dir)
    end

    def c_files_recursive(dir)
      @c_files.map { |f| absolute_path f }
    end

    def h_files_recursive(dir)
      @h_files.map { |f| absolute_path f }
    end

    def copy_files(files)
    end

    def read(file)
    end

    def exists?(file)
    end
  end
end