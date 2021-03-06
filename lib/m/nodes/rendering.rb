module M::Nodes
  module Rendering
    
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
          return if performed?
          process_page_parts
          render_page
        }
      end
    end

    private

    def show_edit_link_on_admin_menu
      @editable_cms_page = true # this flag triggers "edit this page" link in admin menu
    end

    def process_webform
      @webform = resource.respond_to?(:webform) ? resource.webform : nil
      if @webform.present?
        @webform_data = @webform.template.capitalize.constantize.new params[@webform.template]
        @webform_data.webform = @webform
        process_webform_submit if request.post?
      end
    end

    def process_webform_submit
      if @webform_data.save
        flash[:notice] = @webform.thanks_message || Key['webform.thanks']
        if !@webform.thanks_path.blank?
          redirect_to @webform.thanks_path == 'home' ? "/" : @webform.thanks_path
        else
          redirect_to(resource.url)
        end
      end
    end

    def process_redirect
      if resource.skip_top_level_page?
        redirect_to resource.children.first
      elsif !resource.redirect_to.blank?
        redirect_to resource.redirect_to
      end
    end

    def process_page_parts
      page_content = resource.node_content
      @body = page_content.blank? ? '' : (resource.show_draft ? page_content.draft_content : page_content.content) #.gsub(/\"/,'\\\"')
      @sidebar = resource.snippet_id ? resource.snippet.content : nil
    end

    def process_page_title
      resource_title = resource.title
    end

    def process_draft
      resource.show_draft = true if params[:draft] or resource.draft?
    end

    def render_page
      if resource.is_root
        render :template => 'nodes/home', :layout => 'application'
      else
        render :template => "nodes/#{resource.class.to_s.underscore.downcase}", :layout => 'node'
      end
    end
  end
end