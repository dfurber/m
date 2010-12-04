class Admin::BaseController < ApplicationController
  extend ActiveSupport::Concern

  layout 'admin'
  before_filter :authenticate_user!

  protected
      
  def is_admin_page?
    true
  end


end