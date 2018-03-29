require 'trot/version'
require 'trot/utils'
require 'trot/config'
require 'trot/maker'

require 'trot/compiler'
require 'trot/run'
require 'trot/builder'

include Trot

$fs = Trot::FS.new
$compiler = Trot::Compiler::GCC.new
$trot_build_dir = $fs.absolute_path '.trotBuild'
$config = Config.new
