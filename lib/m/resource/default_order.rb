module M::Resource::DefaultOrder
  extend ActiveSupport::Concern
  included do
    class << self
      def default_order(col)
        self.collection_table_default_order = col
      end
    end
  end
end