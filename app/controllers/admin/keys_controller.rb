class Admin::KeysController < Admin::BaseController

  adminify

  collection_table do |t|
    t.column :name, :header => 'Key'
    t.column :typecast, :header => 'Type'
    t.column :display_value, :header => 'Value'
    t.row_actions :edit
  end
  resource_form do |f|
    f.input :value
  end
  search_field :name_or_value, :filter, :as => :string, :label => 'Filter'
  default_order :name
  paginate
  
end