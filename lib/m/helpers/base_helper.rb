# Methods added to this helper will be available to all templates in the application.
module M::Helpers::BaseHelper
  
  def title
    if @title.present?
      if @title.is_a?(Array)
        @title.join(' - ')
      else
        "#{@title} - #{Key['site.name']}"
      end
    elsif resource.present?
      "#{resource.browser_title || resource.title} - #{Key['site.name']}"
    else
      Key['site.name']
    end
  end
  
  def meta_description
    if resource
      if resource.respond_to?(:description) and not resource.description.blank?
        return resource.description
      elsif @body
        truncate(@body, :length => 120)
      end
    end
    Key['meta.description']
  end
  
  def meta_keywords
    if resource and resource.respond_to?(:keywords) and not resource.keywords.blank?
      resource.keywords
    else
      Key['meta.keywords']
    end
  end
  
  def add_script(script)
    @scripts ||= []
    @scripts << script unless @scripts.include?(@script)
  end
  
  def add_stylesheet(stylesheet)
    @stylesheets ||= []
    @stylesheets << script unless @stylesheets.include?(@stylesheets)
  end
  
  # Refactor to remove children.where hacks from the Mongoid days
  def render_main_menu
    html = "".html_safe
    home_page = Page.root
    if home_page
      html << "<li><a href=\"/\" class=\"#{m_active_class(home_page)}\"><span>Home</span></a></li>".html_safe
      if current_user
        tree = home_page.menu_children.where(:show_on_menu => true)
      else
        tree = home_page.public_children
      end
      tree.each do |branch|
        html << "<li>#{link_to(content_tag(:span, branch.title_for_menu).html_safe, branch.url_alias, :class => m_active_class(branch))}".html_safe
        if branch.show_menu_expanded
          leaves = current_user ? branch.menu_children.where(:show_on_menu => true) : branch.public_children
          if leaves.present?
            html << "<ul class=\"subnav\">".html_safe
            leaves.each do |leaf|
              html << content_tag(:li, link_to(content_tag(:span, leaf.title_for_menu).html_safe, leaf.url_alias, :class => m_active_class(leaf)).html_safe).html_safe
            end
            html << "</ul>".html_safe
          end
        end
        html << "</li>".html_safe
      end
    end
    html
  end
  
  def render_sidebar_menu
    if resource.show_menu_on_sidebar && resource.show_menu_on_sidebar > 0
      render :partial => 'shared/sidebar_menu'
    end
  end
  
  def sidebar_menu_link_to(page, *args)
    title = page.title_for_menu
    if not page.redirect_to.blank?
      url = page.redirect_to
    elsif page.respond_to? :url
      url = page.url
    else
      url = args.blank? ? "/" : args.first
    end
    url.sub!(/\/$/,'') 
    html_options = {}
    html_options.merge!(:class => "active") if url == request.request_uri.sub(/\/$|\.html$/,'')
    content_tag(:li, link_to(title, url).html_safe, html_options).html_safe
  end  
  
  def m_current_page?(path)
    path = "/" if path.blank?
    path == request.fullpath
  end
  
  def m_active_class(page)
    m_current_page?(page.path) ? 'active' : nil
  end
  
  def site_bar_switch_link
    if request.fullpath =~ /(^\/admin)|(\/edit$)/
      switch_link = %w{edit new update create}.include?(params[:action]) && resource && resource.respond_to?(:url_alias) ? resource.url_alias : root_path
      link_to 'Swith to your website', switch_link
    else
      link_to 'Switch to admin panel', '/admin'
    end
  end
  
  def content_class
    if content_for?(:left_sidebar) and content_for?(:right_sidebar)
      'three-cols'
    elsif content_for?(:left_sidebar)
      'sidebar-left'
    elsif content_for?(:right_sidebar)
      'sidebar-right'
    end
  end
  
  def assignable_roles
    Role.to_collection
  end
  
  def blog_categories
    BlogCategory.all
  end
  
  def blog_authors
    User.order(:login).select("id, first_name, last_name").map { |user| ["#{user.first_name} #{user.last_name}", user.id] }
  end
  
  def admin_scripts
    javascript_include_tag %w{jquery.hoverintent jquery.timers admin/ruledtable admin/tabcontrol admin/admin}
  end
  
  def show_robots_meta_tag?
    RAILS_ENV != "production"
  end

  # outputs the Javascript necessary to include google analytics
  def google_analytics_include_tag
    return unless RAILS_ENV == "production"
    gaJsHost = "#{(request.protocol == "http://") ? "http://www." : "https://ssl."}google-analytics.com/ga.js"
    output  = "<script type=\"text/javascript\">"
    # output += "var gaJsHost = ((\"https:\" == document.location.protocol) ? \"https://ssl.\" : \"http://www.\");"
    # output += "var gaJsHost = \"#{gaJsHost}\";"
    output += "document.write(unescape(\"%3Cscript src='#{gaJsHost}' type='text/javascript'%3E%3C/script%3E\"));"
    output += "</script>"
    output += "<script type=\"text/javascript\">"
    output += "var pageTracker = _gat._getTracker(\"UA-4542563-2\");"
    output += "pageTracker._initData();"
    output += "pageTracker._trackPageview();"
    output += "</script>"
    output += javascript_include_tag "http://cetrk.com/pages/scripts/0009/9591.js"
  end
  
  # This strips off the div class=fieldWithErrors that comes automatically with Rails
  ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
    if html_tag.include?("class=")
      html_tag.sub(%r{(class=["'])}, '\1error ')
    else
      html_tag.sub(%r{(<[^ ]+ )}, '\1class="error" ')
    end
  end
  
  # Makes the TH of a column sortable. 
  def sort_column(title, column, options = {})
    condition = options[:unless] if options.has_key?(:unless)
    sort_dir = params[:d] == 'up' ? 'down' : 'up'
    link_class = (params[:d] == 'up' ? 'headerSortUp' : 'headerSortDown') if params[:c] == column.to_s
    content_tag(:th, link_to_unless(condition, title, request.parameters.merge( {:c => column, :d => sort_dir})), :class => "header #{link_class}").html_safe
  end

  def file_icon(file)
    ct = file.file_file_name
    if ct =~ /pdf/
      image_tag('admin/pdf.png')
    elsif ct =~ /doc/
      image_tag('admin/doc.png')
    elsif ct =~ /xls/
      image_tag('admin/xls.png')
    elsif ct =~ /ppt/
      image_tag('admin/ppt.png')
    elsif ct =~ /zip/
      image_tag('admin/zip.png')
    elsif file.file.content_type =~ /image/
      image_tag('admin/img.png')
    end
  end

end
