module Trot
  class << self
    def run
      Trot.build
      target = $config.build_target
      args = ARGV.drop(1).join(' ')
      system("#{target} #{args}")
    end
  end
end