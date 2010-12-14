module M
  module Helpers
    module CollectionHelper
      def collection_from_resource_form_helper(field)
        if field[:collection]
          field[:collection]
        elsif field[:collection_model]
          collection_scope = field[:collection_scope] || :all
          field[:collection_model].to_s.constantize.send(collection_scope)
        end
      end
    end
  end
end