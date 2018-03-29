module Trot
  class Target
    ATTRS = [
      :name,
      :src,
      :dest,
      :is_default,
      :is_static_lib
    ]
    attr_reader(*ATTRS)

    def initialize(target_config, opts)
      @config = target_config
      @name = @config['name'] || (@is_default ? 'default' : "t#{opts[:i]}")
      @is_default = opts[:default]
      @is_static_lib = @config['staticLib'] == true

      @src = get_source
      @dest = get_dest
      # src: src_for_target(tgt),
      # dest: tgt['dest'],
      # includePaths: tgt['includePaths'] || nil,
      # libraryPaths: tgt['libraryPaths'] || nil,
      # libraries: tgt['libraries'] || nil,
      # includeDest: tgt['includeDest'] || nil,
      # staticLib: tgt['staticLib'] || false
    end
    
    def to_s
      {
        name: @name,
        src: @src,
        dest: @dest,
        is_default: @is_default
      }.to_s
    end
    
    private

    def get_source
      src = @config['src']
      source = {include: ['']}
      if src.class == String
        source[:include] = [src]
      elsif src.class == Array
        source[:include] = src
      elsif src.class == Hash
        source[:include] = in_array(src['include']) if src['include']
        source[:exclude] = in_array(src['exclude']) if src['exclude']
      end
      source
    end

    def in_array(val)
      if val.class == Array
        val
      else
        [val]
      end
    end

    def get_dest
      dst = @config['dest'] || @name
      if @is_static_lib && !dst.end_with?('.a')
        dst << '.a'
      end
      dst
    end
  end
end