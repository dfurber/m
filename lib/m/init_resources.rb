M.configure do |m|

  m.perm 'Site Administration', 'view admin menu'
  m.perm 'Site Administration', 'edit sitemap'

  m.namespace :admin do |admin|
    admin.resource :Snippet
    admin.resource :Webform, :namespace => :admin, :skip_new => true
    admin.resource :User, :tab => {:group => :user}
    admin.resource :Role, :tab => {:group => :user}
    admin.resource :Permission, :tab => {:group => :user, :perm => 'access roles'}, :tab_only => true
    admin.resource :Key, :tab => {:group => :settings, :name => 'Configuration Keys'}
  end

  m.resource :Page do |r|
    r.perms 'show/hide page on site menu'
  end


end
