require 'fileutils'

module Trot
  class Builder
    def initialize(target)
      @target = target
    end

    def build
      puts 'target', @target
      object_files = []
      source_files_to_compile = []
      puts '.>>>>> sources', source_files
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
      @is_static_lib ||= @target.is_static_lib
    end

    def object_files_directory
      @object_files_directory ||= File.join($trot_build_dir, @target.is_default ? '' : @target.name, 'objectFiles')
    end

    def source_files
      @source_files ||= Proc.new() {
        includes = @target.src[:include]
        excludes = @target.src[:exclude] || []
        puts '>>>> including', includes
        puts '>>>>>> excluding', excludes
        src_files = Set.new;
        includes.each { |f| src_files += $fs.files_recursive(f) }
        excludes.each { |x| src_files -= $fs.files_recursive(x) }
        src_files.to_a.select { |f| f =~ /\.c$/ }
      }.call
    end

    def header_files
      # @header_files ||= $fs.h_files_recursive(@target[:sourceDir])
    end

    def target_path
      @target_path ||= $fs.absolute_path @target.dest
    end

    def target_name
      @target_name ||= File.basename(target_path)
    end

    def target_dir
      @target_dir ||= File.dirname(target_path)
    end
  end
end
