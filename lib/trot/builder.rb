require 'fileutils'

module Trot
  class Builder
    def initialize(target)
      @target = target
    end

    def build
      object_files = []
      source_files_to_compile = []
      source_files.each { |source_file|
        file_name = File.basename(source_file, '.c')
        object_file = File.join(object_files_directory, "#{file_name}.o")
        object_files << object_file
        if Make.should_update_target(source_file, object_file)
          source_files_to_compile << source_file
        end
      }
      compile_objects(source_files_to_compile)
      copy_header_files
      link_object_files(object_files)
    end

    def copy_header_files
      puts "copying header files", @target
    end

    def compile_objects(source_files_to_compile)
      $fs.ensure_dir object_files_directory
      $compiler.compile(source_files_to_compile, object_files_directory) unless source_files_to_compile.empty?
    end

    def link_object_files(object_files)
      return if object_files.empty?
      return unless Make.should_update_target(object_files, target_path)
        
      $fs.ensure_dir target_dir
      
      if is_static_lib?
        $compiler.link_static_lib(object_files, target_path)
      else
        $compiler.link(object_files, target_path)
      end
    end

    private

    def is_static_lib?
      @is_static_lib ||= @target[:staticLib] == true
    end

    def object_files_directory
      @object_files_directory ||= File.join($trot_build_dir, @target[:name], 'objectFiles')
    end

    def source_files
      @source_files ||= $fs.c_files_recursive(@target[:sourceDir])
    end

    def header_files
      @header_files ||= $fs.h_files_recursive(@target[:sourceDir])
    end

    def target_path
      @target_path ||= Proc.new() {
        path = $fs.absolute_path @target[:dest]
        if is_static_lib? && !path.end_with?('.a')
          path << (path.end_with?('.') ? 'a' : '.a')
        end
        path
      }.call
    end

    def target_name
      @target_name ||= File.basename(target_path)
    end

    def target_dir
      @target_dir ||= File.dirname(target_path)
    end
  end
end
