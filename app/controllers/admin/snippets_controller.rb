class Admin::SnippetsController < Admin::BaseController

  adminify  

  before_create :set_user_for_activity
  before_update :set_user_for_activity
  
  resource_form do |f|
    f.input :name
    f.input :content
  end
  
  private
  
  def set_user_for_activity
    resource.user = current_user
  end
  
  
end