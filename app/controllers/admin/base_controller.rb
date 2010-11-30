class Admin::BaseController < ApplicationController

  before_filter :authenticate_user!
  resourcify
  paginate
  actions :all, :except => :show

  layout 'admin'
  
  protected
    
  def is_admin_page?
    true
  end


end