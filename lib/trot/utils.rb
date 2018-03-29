require 'fileutils'

module Trot
  class FS
    def absolute_path(path)
      File.join(Dir.pwd, path)
    end

    def ensure_dir(dir)
      FileUtils.mkdir_p dir unless Dir.exist? dir
    end

    def c_files_recursive(dir)
      Dir.glob("#{absolute_path dir}/**/*.c")
    end

    def h_files_recursive(dir)
      Dir.glob("#{absolute_path dir}/**/*.h")
    end

    def files_recursive(pattern)
      glob = Dir.glob("#{absolute_path pattern}")
      files = Set.new
      
      glob.each do |f|
        if Dir.exist? f
          files += Dir.glob(File.join(f, '**/*'))
        else
          files += f
        end
      end
      files.to_a
    end

    def read(file)
      IO.read(file)
    end

    def copy_files(files)
      files.each do |source, dest|
        FileUtils.cp(src, dest)
      end
    end

    def exists?(file)
      File.exists? file
    end
  end
end

