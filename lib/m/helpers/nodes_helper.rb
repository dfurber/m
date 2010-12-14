module M::Helpers::NodesHelper

  def render_node(page, children, locals = {})
    @current_node = page
    locals.reverse_merge!(:level => 0, :simple => false).merge!(:page => page, :children => children)
    render :partial => 'node', :locals =>  locals
  end

  def homepage
    @homepage ||= Page.root
  end

  def children_class
    unless @current_node.children.empty?
      if expanded
        " children-visible"
      else
        " children-hidden"
      end
    else
      " no-children"
    end
  end

  def virtual_class
    @current_node.virtual? ? " virtual": ""
  end

  def icon
    icon_name = @current_node.virtual? ? 'virtual-page' : 'page'
    icon_name = "admin/#{icon_name}.png"
    image_tag(icon_name, :class => "icon", :alt => 'page-icon', :title => '')
  end

  def node_title
    content_tag :span, @current_node.title, :class => 'title'
  end

  def page_type
    content_tag(:small, @current_node.type, :class => 'info')
  end

  def spinner
    image_tag('admin/spinner.gif',
            :class => 'busy', :id => "busy-#{@current_node.id}",
            :alt => "",  :title => "",
            :style => 'display: none;')
  end
  
  def dragger
    image_tag('admin/blank.gif', :class => 'dragger')
  end  
  
end
