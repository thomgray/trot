require 'trot/version'
require 'trot/maker'
require 'trot/build'
require 'trot/run'
require 'trot/utils'
require 'trot/config'

module Trot
  $trot_build_dir = absolute_path '.trot_build'
  $config = Config.new
end
