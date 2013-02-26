module M::Resource::CollectionTable
  extend ActiveSupport::Concern
  included do
    
    def collection_table_columns
      if collection_columns.blank?
        [{:header => resource_collection_name.to_s.gsub(/_/,' ').titleize, :row => :name, :options => {}}]
      else
        collection_columns
      end
    end
    def collection_table_actions
      collection_actions.blank? ? [:edit, :destroy] : collection_actions
    end
    
    class << self
      
      def collection_table(&block)
        self.collection_columns = []
        block.call(self)
        # define_method(:collection_table_columns) {collection_columns} unless collection_columns.empty?
      end
      def column(row, *args)
        options = args.extract_options!
        header = options.delete(:header) || row.to_s.gsub(/_/,' ').titleize
        self.collection_columns << {:header => header, :row => row, :options => (options || {})}
      end
      
      def row_actions(*args)
        self.collection_actions = args
        # define_method(:collection_table_actions) { args }
      end
      
    end
    
  end
  
  # works with the sort_column method to make it so that when you click "Name" on admin page, it sorts the table by name.
  def sort_order(default)
    if params[:c].blank? && default == "created_at"
      "created_at DESC"
    elsif params[:c].blank? && default == "total"
      "total DESC"
    else
      "#{(params[:c] || default.to_s).gsub(/[\s;'\"]/,'')} #{params[:d] == 'down' ? 'DESC' : 'ASC'}"
    end
  end
  
  def collection
    return get_collection_ivar if get_collection_ivar
    chain = end_of_association_chain
    if params[:commit] == 'Reset'
      params.delete :c
      params.delete :d
      params.delete :page
      params.delete :search
    end
    if self.class.search_fields.is_a?(Array)
      @search_form = M::Resource::SearchFields.new params[:search]
      @search_form.alive = true
    end
    if self.class.collection_table_default_order.present?
      chain = chain.order(sort_order(self.class.collection_table_default_order))
    end        

    set_collection_ivar(paginated? ? paginate(chain.all) : chain.all)
  end

  
end