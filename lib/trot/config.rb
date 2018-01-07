require 'json'
require 'yaml'

module Trot
  class Config
    def initialize
      json_trot_path = Trot.absolute_path 'trot.json'
      yaml_trot_path = Trot.absolute_path 'trot.yaml'

      if File.exists? json_trot_path
        @config = JSON.parse(IO.read(json_trot_path))
      elsif File.exists? yaml_trot_path
        @config = YAML.load(IO.read(yaml_trot_path))
        puts @config
      else
        @config = {}
      end
    end

    def source
      if @config['source']
        Trot.absolute_path @config['source']
      else
        Dir.pwd
      end
    end

    def build_target
      build_config = @config['build'] || {}
      target_path = build_config['target'] || 'a.out'
      Trot.absolute_path(target_path)
    end

    def build_target_name
      build_target[/[^\/]+$/]
    end
  end
end
