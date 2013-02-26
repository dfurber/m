class Admin::RolesController < Admin::BaseController

  adminify
  
  collection_table do |t|
    t.row_actions :edit_role_link, :edit_permissions_link, :destroy_role_link
  end
  
  resource_form do |f|
    f.input :name
  end

  def remove
    @role = Role.find params[:id]
  end
  

end