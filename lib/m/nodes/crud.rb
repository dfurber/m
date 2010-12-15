# This module provides the basic index and edit forms for a node type. It is also an example of how to use
# the various features.
module M::Nodes
  module Crud
    extend ActiveSupport::Concern
    included do
      
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

      # def edit_node_path(node, return_to)
      #   "/#{node.class.to_s.underscore}/#{node.id}/edit?return_to=#{request.fullpath}"
      # end

      before_create :ensure_content
      before_create :set_created_by
      before_update :set_updated_by

      paginate  
      search_field :filter, :filter, :as => :string, :label => 'Filter'

      tab :meta, 'Info' do |f|
        f.input :title, :label => 'Page Title', :input_html => {:class => 'title'}
        f.input :slug, :label => 'URL Token', :input_html => {:class => 'slug'}
        f.input :breadcrumb, :input_html => {:class => 'breadcrumb'}
        f.input :redirect_to, :label => 'Redirect', :hint => 'Forward this page to another website or URL.'
        f.input :skip_page, :as => :boolean, :label => 'Skip Top-Level Page', :hint => 'Instead of showing this page, show its first child page.'
        f.association :webform, :label => 'Show a webform' 
        f.association :snippet, :label => 'Sidebar Snippet'
        f.input :status_id, :as => :select, :collection_model => :Node, :collection_scope => :statuses, :include_blank => false
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
      
      def ensure_content
        resource.node_content ||= NodeContent.new
      end

      def set_created_by
        resource.created_by_id = current_user.id
      end

      def set_updated_by
        resource.updated_by_id = current_user.id
      end
      
    end
  
  end
end