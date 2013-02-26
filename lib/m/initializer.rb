module M
  class Initializer
    attr_accessor :options
    def initialize(&block)
      self.options = {}
      block.call(self) if block_given?
    end
    def resource(name, *args, &block)
      o = args.extract_options!
      o.symbolize_keys!
      M::Resource::Initializer.new(name, o.merge(options), &block)
    end
    def namespace(name, &block)
      self.options = {:namespace => name}
      block.call(self) if block_given?
      self.options = {}
    end
    def perm(group, permission)
      M.permissions.add group, permission
    end
  end
  
  def self.configure(&block)
    M::Initializer.new &block
  end
end


