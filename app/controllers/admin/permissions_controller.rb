class Admin::PermissionsController < ApplicationController
  before_filter :authenticate_user!
  layout 'admin'
  
  def index
    authorize! :read, M::Permissions::Permission
    if params[:role_id]
      @roles = [Role.find(params[:role_id])]
    else
      @roles = Role.order(:name)
    end
    process_form_submission if request.post?
  end
  
  private
  
  def process_form_submission
    if params[:role_id]
      role = Role.find params[:role_id]
      role.update_permissions params[:roles][params[:role_id]]
    else
      Role.all.each do |role|
        perms = params[:roles][role.id.to_s] || []
        role.update_permissions perms
      end
    end
    redirect_to :action => :index
  end
  
end