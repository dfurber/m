class ActionController::Base
  
    def self.resourcify
      class_eval do

        inherit_resources
        load_and_authorize_resource :collection => [:sort, :sitemap]

        include M::Resource::Observers
        include M::Resource::Pagination
        include M::Resource::ActionOverrides
        include M::Resource::CollectionTable
        include M::Resource::DefaultOrder
        include M::Resource::FormInputs
        include M::Resource::ResourceForm
        include M::Resource::SearchForm

        class_inheritable_array :collection_columns
        class_inheritable_array :collection_actions
        class_inheritable_accessor :collection_table_default_order
        class_inheritable_accessor :resource_form_object
        class_inheritable_array :search_fields
        
        helper_method :collection_table_columns, :collection_table_actions,
                      :resource_form_inputs, :resource_form_tabs, :resource_form_has_tabs?, :resource_form_has_file_input?,
                      :search_fields

        protected :collection_columns, :collection_actions, :collection_table_default_order, :resource_form_object, :search_fields
      end
    end

end