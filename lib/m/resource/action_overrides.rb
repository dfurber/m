module M::Resource::ActionOverrides
  extend ActiveSupport::Concern
  included do
    include InstanceMethods
  end
  
  module InstanceMethods
    def create(options={}, &block)
      object = build_resource

      if create_resource(object)
        options[:location] ||= get_location rescue nil
      end

      respond_with_dual_blocks(object, options, &block)
    end

    def update
      update!(:location => get_location)
    end

    private
    
    def get_location
      if params[:commit] && params[:commit] != 'Save'
        edit_resource_url
      else
        respond_to?(:show) ? resource_url : collection_url
      end
    end
  end
end