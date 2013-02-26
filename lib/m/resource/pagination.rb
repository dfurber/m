module M::Resource::Pagination
  extend ActiveSupport::Concern
  included do
    extend ClassMethods
    include InstanceMethods
    helper_method :paginated?
  end
  
  module ClassMethods
    def paginate(*args)
      options = args.extract_options!
      options.symbolize_keys!
      class_eval "def paginate(chain); chain.paginate(:page => params[:page], :per_page => #{options[:per_page] || 50}); end"
      class_eval "def paginated?; true; end"
    end
  end
  
  module InstanceMethods
    def paginated?
      false
    end
  end
end