module Trot
  module Compiler
    class GCC
      def compile(sources, target_dir)
        sources.each do |src|
          target = File.join(target_dir, "#{File.basename(src, '.*')}.o")
          execute "gcc #{compiler_opts} -c #{src} -o #{target}"
        end
        # is this better? it makes the command potentially a lot larget, but the linking command is anyway
        # Dir.chdir(target_dir) {
        #   execute "gcc #{compiler_opts} -c #{sources.join(' ')}"
        # }
      end

      def link(object_files, target)
        execute "gcc #{compiler_opts} #{object_files.join(' ')} -o #{target}"
      end

      def link_static_lib(object_files, target)
        execute "gcc #{compiler_opts} #{object_files.join(' ')} -o #{target}"
      end

      private

      def execute(cmd)
        $logger.info(cmd)
        system(cmd)
      end

      def compiler_opts
        @compiler_opts ||= Proc.new() {
          opts = []
          if $config.compiler_opts[:debug]
            opts << '-W'
          end
          opts.join(' ')
        }.call
      end
    end
  end
end
