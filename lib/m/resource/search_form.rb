module M::Resource
  class SearchFields < SymbolTable
    include ActiveModel::Validations
    def self.model_name
      name = "search"
      name.instance_eval do
        def plural;   pluralize;   end
        def singular; singularize; end
        def human;    singularize; end # only for Rails 3
        def i18n_key; 'search';   end
      end
      return name
    end
    def attributes
      self
    end
  end
  module SearchForm
    extend ActiveSupport::Concern

    included do
      
      def search_fields
        self.class.search_fields
      end

      class << self
        def search_field(scope_name, param, *args)
          options = args.extract_options!
          options.symbolize_keys!
          self.search_fields ||= []
          field = {:scope_name => scope_name, :param => param}
          scope_options = { :only => :index, :as => :search, :using => param, :unless => :resetting_search_form? }
          scope_options.merge!(:type => options.delete(:type)) if options[:type].present?
          field.merge! :input => options
          has_scope scope_name, scope_options
          self.search_fields << field
        end
      end
    end
    def resetting_search_form?
      params[:commit] && params[:commit] == "Reset"
    end
    
  end
end