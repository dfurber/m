class Admin::RolesController < Admin::BaseController

  paginate
  
  collection_table do |t|
    t.row_actions :edit_role_link, :edit_permissions_link, :destroy_role_link
  end

  def remove
    @role = Role.find params[:id]
  end
  

end