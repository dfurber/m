class M::Resource::Base < ::ApplicationController
  
    def self.resourcify(base)
      base.class_eval do

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

        base.with_options :instance_writer => false do |c|
          c.class_inheritable_array :collection_columns#, :instance_writer => false
          c.class_inheritable_array :collection_actions#, :instance_writer => false
          c.class_inheritable_accessor :collection_table_default_order, :instance_writer => false
          c.class_inheritable_accessor :resource_form_object
          c.class_inheritable_array :search_fields, :instance_writer => false
        end
        
        helper_method :collection_table_columns, :collection_table_actions,
                      :resource_form_inputs, :resource_form_tabs, :resource_form_has_tabs?, :resource_form_has_file_input?,
                      :search_fields

        # protected :resource_class, :parents_symbols, :resources_configuration
      end
    end

    resourcify(self)
 
end