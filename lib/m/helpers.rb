module M
  module Helpers
  end
end

Dir.entries(File.join(File.dirname(__FILE__), 'helpers')).each do |file|
  require File.join(File.dirname(__FILE__), 'helpers', file) if file =~ /\.(rb)$/
end

class ActionView::Base
  include M::Helpers::BaseHelper
  include M::Helpers::NodesHelper
  include M::Helpers::RolesHelper
  include M::Helpers::CollectionHelper  
end