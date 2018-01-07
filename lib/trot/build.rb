require 'fileutils'

module Trot
  class << self
    def build
      object_files_directory = File.join($trot_build_dir, 'object_files')
      ensure_dir object_files_directory

      source_files = Dir.glob("#{$config.source}/**/*.c")
      target_path = $config.build_target
      target_name = $config.build_target_name
      target_dir = File.dirname(target_path)
      ensure_dir target_dir

      source_files_to_compile = Array.new
      object_files = Array.new

      source_files.each { |source_file|
        file_name = File.basename(source_file, '.c')
        object_file = File.join(object_files_directory, "#{file_name}.o")
        object_files << object_file
        if Make.should_update_target(source_file, object_file)
          source_files_to_compile << source_file
        end
      }

      Dir.chdir(object_files_directory){
        system("gcc -Wall -c #{source_files_to_compile.join(' ')}") unless source_files_to_compile.empty?
      }
      Dir.chdir(target_dir){
        system("gcc #{object_files.join(' ')} -o #{target_name}") unless object_files.empty?
      }
    end
  end
end