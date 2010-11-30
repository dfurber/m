class Admin::NodesController < Admin::BaseController

  before_filter :build_body, :only => [:new, :edit]
  before_destroy :announce_pages_removed
    
  def remove
    @node = Node.find(params[:id])
  end

  def move
    @parent = Node.find params[:parent_id]
    @node = Node.find params[:id]
    position = params[:position].to_i
    if @node.parent != @parent
      @node.parent = @parent
      @node.save
    end
    @node.insert_at position
    render :nothing => true
  end
  
  def toggle
    resource.show_on_menu = !resource.show_on_menu
    if resource.save
      flash[:notice] = "Page <strong>#{resource.title}</strong> is #{!resource.show_on_menu ? "not " : ""} visible on the menu."
    else
      flash[:errors] = "Could not toggle the menu visibility of <strong>#{resource.title}</strong>"
    end
    redirect_to :action => :index
  end
  
  def clear_cache
    Node.clear_cache
    flash[:notice] = "Page cache cleared!"
    redirect_to :back
  end
  
  private

    def announce_pages_removed
      count = resource.children.count + 1
      flash[:notice] = if count > 1
        "The pages were successfully removed from the site."
      else
        "The page was successfully removed from the site."
      end
    end

    def collection
      @homepage ||= Node.root
    end

    
end
