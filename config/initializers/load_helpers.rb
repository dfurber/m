module M
  module Helpers
  end
end

require 'm/helpers/base_helper'
# require 'm/helpers/collection_helper'
require 'm/helpers/form_helper'
require 'm/helpers/nodes_helper'
require 'm/helpers/roles_helper'
require 'm/helpers/simple_form'

class ActionView::Base
  include M::Helpers::BaseHelper
  include M::Helpers::NodesHelper
  include M::Helpers::RolesHelper
  include M::Helpers::CollectionHelper  
end