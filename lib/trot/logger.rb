module Trot
  class Logger
    def info(string)
      STDOUT.puts("\e[32;1m[INFO]: \e[22m#{string}\e[0m") if $config.verbose
    end
  end
end