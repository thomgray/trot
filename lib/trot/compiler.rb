require_relative 'compiler/gcc'

module Trot
  module Compiler
    def self.get
      GCC.new
    end
  end
end
