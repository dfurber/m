module M::Helpers::RolesHelper
  def edit_role_link(role)
    role.locked ? 'locked' : link_to('edit role', edit_resource_path(role)).html_safe
  end
  def edit_permissions_link(role)
    link_to('edit permissions', admin_permissions_path(role)).html_safe
  end
  def destroy_role_link(role)
    role.locked? ? '' : link_to('delete role', resource_path(role), :method => :delete, :confirm => 'Are you sure?').html_safe
  end
  
end