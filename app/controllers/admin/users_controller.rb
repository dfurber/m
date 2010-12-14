class Admin::UsersController < Admin::BaseController

  adminify
  
  before_create :assign_role
  before_update :assign_role
  
  collection_table do |t|
    t.column :login, :header => 'Username', :sortable => true
    t.column :email, :header => 'Email', :sortable => true
    t.column :role_name,  :header => 'Roles'
  end

  search_field :filter, :filter, :as => :string, :label => 'Login or email'
  search_field :role_filter, :role, :as => :select, :label => 'Role', :collection_helper => :assignable_roles
  default_order :login
  paginate
  
  resource_form do |f|
    f.input :login
    f.input :email
    f.input :first_name
    f.input :last_name
    f.input :password
    f.input :password_confirmation, :type => :password, :label => "Confirm password"
    f.association :roles,   :as => :check_boxes, :collection_model => :Role, :collection_scope => :to_collection, :label => 'Roles'
  end
    
  def assign_role
    @user.role_ids = params[:user][:role_ids].reject {|r| r.blank? }
  end
     
end