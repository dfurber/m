class NodesController < ApplicationController
  
  nodify
  
  # Needs to watch out for draft status...
  # also need to either not cache the layout or put the main menu back into after filter...
  # caches_action :show, :cache_path => proc do |controller| 
  #   uri = controller.request.request_uri.chomp("/")
  #   uri = "home" if uri.blank?
  #   uri
  # end
  
  private
  
  def edit_node_url(*args)
    node = args.first
    send("edit_#{node.class.to_s.underscore}_url", node)
  end
  def node_url(*args)
    node = args.first
    send("#{node.class.to_s.underscore}_url", node)
  end
  helper_method :node_url, :edit_node_url

  
end
