require 'json'
require 'yaml'

module Trot
  class Config
    attr_reader :targets, :compiler_opts, :verbose

    def initialize(options = {})
      json_trot_path = $fs.absolute_path 'trot.json'
      yaml_trot_path = $fs.absolute_path 'trot.yaml'

      if $fs.exists? json_trot_path
        @config = JSON.parse($fs.read(json_trot_path)) || {}
      elsif $fs.exists? yaml_trot_path
        @config = YAML.load($fs.read(yaml_trot_path)) || {}
      else
        @config = {}
      end

      @verbose = options.has_key?(:verbose) ? options[:verbose] : @config['verbose']
      @targets = gather_targets(options)
      @compiler_opts = gather_compiler_opts(options)
    end

    def target(name)
      targets.find { |t| t.name == name }
    end

    private

    def gather_targets(options)
      tgts = @config['targets']
      if tgts && tgts.length
        raise InvalidConfigError, "'targets' must be a array" unless tgts.class == Array
        # raise InvalidConfigError, "'targets' must be non-empty" unless tgts.length
        return tgts.map { |t, i| Target.new(t, {i: i}) }
      end
      return [
        Target.new(@config, {default: true})
      ]
    end

    def gather_compiler_opts(options)
      opts = {}
      if @config['compilerOpts'] && @config['compilerOpts'].class == Hash
        config_opts = @config['compilerOpts']
        opts[:debug] = options.has_key?(:debug) ? options[:debug] : config_opts['debug']
      end
      opts
    end
  end
  
  class InvalidConfigError < StandardError
  end
end
