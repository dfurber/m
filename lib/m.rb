module M
  mattr_accessor :config, :permissions, :admin_tabs, :root
end

M.root = File.join(File.dirname(__FILE__), '..')

require 'devise'
require 'meta_where'
require 'compass'
require 'haml'
require 'cancan'
require 'paperclip'
require 'has_scope'
require 'inherited_resources'
require 'inherited_resources_views'
require 'simple_form'
require 'will_paginate'
require 'ancestry'
require 'symboltable'

require 'm/initializer'
require 'm/permissions/permission'
require 'm/permissions/group'
require 'm/permissions/list'
require 'm/helpers/collection_helper'
require 'm/resource'
require 'm/resource/base'
require 'm/nodes/crud'
require 'm/nodes/rendering'
require 'm/nodes/nodify'

# add railtie
if defined?(Rails)
  require "m/rails/railtie"
  require "m/rails/engine"
end


