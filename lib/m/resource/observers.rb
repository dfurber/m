module M
  module Resource
    module Observers
      extend ActiveSupport::Concern
      included do
        extend ActiveModel::Callbacks
        define_model_callbacks :create, :update, :destroy

        include InstanceMethods 

        alias_method_chain :create_resource, :events
        alias_method_chain :update_resource, :events
        alias_method_chain :destroy_resource, :events      
      end

      module InstanceMethods
        def create_resource_with_events(object)
          _run_create_callbacks do
            create_resource_without_events(resource)
          end
        end

        def update_resource_with_events(object, attributes={})
          _run_update_callbacks do
            update_resource_without_events(object, attributes)
          end
        end

        def destroy_resource_with_events(object)
          _run_destroy_callbacks do
            destroy_resource_without_events(object)
          end
        end
      end
    end
  end
end