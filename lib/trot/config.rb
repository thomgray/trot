require 'json'
require 'yaml'

module Trot
  class Config
    def initialize
      json_trot_path = $fs.absolute_path 'trot.json'
      yaml_trot_path = $fs.absolute_path 'trot.yaml'

      if $fs.exists? json_trot_path
        @config = JSON.parse($fs.read(json_trot_path)) || {}
      elsif $fs.exists? yaml_trot_path
        @config = YAML.load($fs.read(yaml_trot_path)) || {}
      else
        @config = {}
      end
    end

    def source
      if @config['sourceDir']
        $fs.absolute_path @config['sourceDir']
      else
        Dir.pwd
      end
    end

    def targets
      tgts = @config['targets']
      if tgts && tgts.length
        raise InvalidConfigError, "'targets' must be a array" unless tgts.class == Array
        # raise InvalidConfigError, "'targets' must be non-empty" unless tgts.length
        return tgts.map { |t| normalise_target t }
      end
      return [
        normalise_target(
          @config.merge({'name' => @config['name'] || 'default'})
        )
      ]
    end

    def target(name)
      targets.find { |t| t[:name] == name }
    end

    def compiler_opts
      opts = {}
      if @config['compilerOpts'] && @config['compilerOpts'].class == Hash
        config_opts = @config['compilerOpts']
        opts[:debug] = config_opts['debug']
      end
      return opts
    end

    def build_target
      build_config = @config['build'] || {}
      target_path = build_config['target'] || 'a.out'
      $fs.absolute_path(target_path)
    end

    private

    def normalise_target(tgt)
      {
        name: tgt['name'],
        sourceDir: tgt['sourceDir'] || '',
        dest: tgt['dest'],
        includePaths: tgt['includePaths'] || nil,
        libraryPaths: tgt['libraryPaths'] || nil,
        libraries: tgt['libraries'] || nil,
        includeDest: tgt['includeDest'] || nil,
        staticLib: tgt['staticLib'] || nil
      }.delete_if { |k, v| v.nil? }
    end
  end
  
  class InvalidConfigError < StandardError
  end
end
