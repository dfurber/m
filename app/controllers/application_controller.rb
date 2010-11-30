# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :init_request
  around_filter :add_dynamic_html
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = 'Access Denied'
    redirect_to login_path
  end
  
  protected
  
  def init_request
    @title = [M.config.name]
    @stylesheets = []
    @scripts = []
  end
  
  def add_dynamic_html
    yield
    unless @performed_redirect
      add_flash
      add_admin_menu
    end
  end
  
  # We add the flash messages using after filter so we can use action caching and still customize the page to the user.
  # This is an AROUND FILTER - the yield is the before part. Has to be around instead of after because caches_action applies
  # an around filter which halts the filter chain before after filters are executed!
  def add_flash
    unless flash.empty?
      notifications = "".html_safe
      unless flash[:notice].blank?
        notifications << "<div class=\"notification\">#{flash[:notice].html_safe}#{close_notice}</div>".html_safe
      end
      unless flash[:errors].blank?
        notifications << "<div class=\"error\">#{flash[:errors].html_safe}#{close_notice}</div>".html_safe
      end
      unless flash[:alert].blank?
        notifications << "<div class=\"alert\">#{flash[:alert].html_safe}#{close_notice}</div>".html_safe
      end
      response.body = response.body.sub /<!-- Notifications -->/, notifications.html_safe
    end
  end
  
  # This adds the admin menu and keeps us from having to make the user include in their layout.
  def add_admin_menu
    if current_user and current_user.can?('view admin menu')
      admin_menu = render_to_string(:partial => 'layouts/shared/admin_menu')
      start_of_body_tag = response.body =~ /<body.*?>/
      if start_of_body_tag
        response.body = response.body.insert(start_of_body_tag, admin_menu)
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
  
  def is_admin_page?
    false
  end
  helper_method :is_admin_page?
  
  def access_denied
    flash[:errors] = "You must be logged in to see this page."
    redirect_to new_user_session_path(:return_to => request.request_uri)
  end
  
  
  def logged_in?
    current_user ? true : nil
  end
  helper_method :logged_in?
  helper_method :current_user

  def close_notice
    "<a href=\"#\" id=\"close_notice\" onclick=\"$(this).parent().fadeOut('fast');return false;\">close</a>"
  end
  
  def resource
    nil
  end
  helper_method :resource

  
end
