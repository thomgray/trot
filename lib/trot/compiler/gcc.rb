module Trot
  module Compiler
    class GCC
      def compile(sources, target_dir)
        Dir.chdir(target_dir) {
          system("gcc #{compiler_opts} -c #{sources.join(' ')}")
        }
      end

      def link(object_files, target)
        system("gcc #{compiler_opts} #{object_files.join(' ')} -o #{target}")
      end

      def link_static_lib(object_files, target)
        system("gcc #{compiler_opts} #{object_files.join(' ')} -o #{target}")
      end

      def compiler_opts
        @compiler_opts ||= Proc.new() {
          opts = ''
          if $config.compiler_opts[:debug]
            opts << ' -W'
          end
          opts
        }.call
      end
    end
  end
end
