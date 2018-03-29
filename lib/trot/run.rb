module Trot
  class << self
    def run(target)
      # Trot.build(target)
      target = $config.build_target
      args = ARGV.drop(1).join(' ')
      system("#{target} #{args}")
    end
  end
end