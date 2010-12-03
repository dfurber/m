class NodesController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:show]
  layout 'admin', :except => [:show]
  
  resourcify
  include NodeRendering
  actions :all

  # Needs to watch out for draft status...
  # also need to either not cache the layout or put the main menu back into after filter...
  # caches_action :show, :cache_path => proc do |controller| 
  #   uri = controller.request.request_uri.chomp("/")
  #   uri = "home" if uri.blank?
  #   uri
  # end
  
  def show
    show! do |format|
      format.html {
        if resource.blank?
          render :text => 'File Not Found', :status => 404 
          return
        end
        show_edit_link_on_admin_menu
        process_draft
        process_redirect
        process_page_title
        process_webform
        process_page_parts
        render_page
      }
    end
  end

  private
  
  def resource
    return get_resource_ivar if get_resource_ivar
    if params[:id]
      set_resource_ivar(end_of_association_chain.find(params[:id]))
    elsif params[:url]
      params[:url] = "/#{params[:url].sub(/\.html/, '')}"
      set_resource_ivar(end_of_association_chain.find_by_url_alias_and_show_on_site_map(params[:url], true))
    else
      set_resource_ivar(Node.root)
    end
  end
  
  def edit_node_path(node, return_to)
    "/#{node.class}/#{node.id}/edit?return_to=#{request.fullpath}"
  end
  
  before_create :set_created_by
  before_update :set_updated_by

  paginate  
  search_field :filter, :filter, :as => :string, :label => 'Filter'

  tab :meta, 'Info' do |f|
    f.input :title, :label => 'Page Title', :input_html => {:class => 'title'}
    f.input :slug, :input_html => {:class => 'slug'}
    f.input :breadcrumb, :input_html => {:class => 'breadcrumb'}
    f.input :redirect_to, :label => 'Redirect', :hint => 'Forward this page to another website or URL.'
    f.input :skip_page, :as => :boolean, :label => 'Skip Top-Level Page', :hint => 'Instead of showing this page, show its first child page.'
    f.association :webform, :label => 'Show a webform' #, :collection => Webform.all
    f.input :status, :collection_model => :Node, :collection_scope => :statuses, :include_blank => false
  end
  
  tab :menu, 'Menu' do |f|
    f.input :show_on_site_map, :label => 'Put this page on the Site Map', :as => :boolean
    f.input :parent_id, :as => :select, :collection_model => :Node, :collection_scope => :nodes_on_site_map
    f.input :menu_title, :label => 'Title on Menu', :hint => 'Custom title for this page on the site menu.'
    f.input :show_on_menu, :as => :boolean, :label => 'Display this page in the site menu.'
    f.input :show_menu_expanded, :as => :boolean, :label => 'On the main site menu, should this page be expanded if it has children? (useful for dropdowns)'
    f.collection_radios :show_menu_on_sidebar, :collection_model => :Node, :collection_scope => :sidebar_menu_options, :value => :last, :text => :first, :label => 'Sidebar Menu', :hint => 'Should this page have a sidebar menu?'
  end

  tab :body, 'Body' do |f|
    f.input :body_for_editing, :as => :text, :label => 'Body content'
  end
  
  tab :seo, 'SEO', do |f|
    f.input :browser_title, :label => 'Browser Title', :hint => 'Text to show in browser title bar.'
    f.input :keywords, :label => 'Meta Keywords'
    f.input :description, :as => :text, :label => 'Meta Description'
    f.input :author
  end
  
  def set_created_by
    resource.created_by_id = current_user.id
  end
  
  def set_updated_by
    resource.updated_by_id = current_user.id
  end

  
end
