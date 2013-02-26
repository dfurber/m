module M::Nodes
  module Nodify
    extend ActiveSupport::Concern
    included do
      before_filter :authenticate_user!, :except => [:show]
      layout 'admin', :except => [:show]

      resourcify
      include M::Nodes::Rendering
      include M::Nodes::Crud
      actions :all
    end
  end
end