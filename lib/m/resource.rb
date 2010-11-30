module M
  module Resource
    
    autoload :Initializer,     'm/resource/initializer'
    autoload :Base,            'm/resource/base'
    autoload :Observers,       'm/resource/observers'
    autoload :Pagination,      'm/resource/pagination'
    autoload :ActionOverrides, 'm/resource/action_overrides'
    autoload :CollectionTable, 'm/resource/collection_table'
    autoload :FormInputs,      'm/resource/form_inputs'
    autoload :Tab,             'm/resource/tab'
    autoload :ResourceForm,    'm/resource/resource_form'
    autoload :DefaultOrder,    'm/resource/default_order'
    autoload :SearchForm,      'm/resource/search_form'
    
  end
end

class ActionController::Base
  def self.resourcify
    M::Resource::Base.resourcify(self)
  end
end

# Override CanCan to use collection rather than end of association chain. Because it sets the ivar using resource_base,
# and then my custom collection helper no more workie because not called.
module CanCan
  # For use with Inherited Resources
  class InheritedResource < ControllerResource # :nodoc:
    def resource_base
      @controller.send :collection
    end
  end
end
