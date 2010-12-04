Key.ensure! :name => 'site.name', :value => (M.config.name || 'Company Name'), :description => 'Site Name'
Key.ensure! :name => 'site.email', :value => (M.config.support_email || 'account@localhost'), :description => 'Site Email'
Key.ensure! :name => 'meta.description', :value => 'Description of the website.', :description => 'Sitewide Description Meta Tag - used when not overridden by page.'
Key.ensure! :name => 'meta.keywords', :value => 'Keywords for website', :description => 'Sitewide Keywords Meta Tag - used when not overridden by page.'
Key.ensure! :name => 'site.admin.can', :value => true, :description => 'Admin Can Do Anything'
Role.ensure! :name => 'anonymous user'
Role.ensure! :name => 'authenticated user'
Role.ensure! :name => 'administrator'
User.ensure_administrator!
Page.ensure_root!

Webform.ensure! :name => 'Contact', :template => 'contact'
Webform.ensure! :name => 'Wedding Contact', :template => 'wedding'
Key.ensure! :name => 'webform.thanks', :value => 'Thanks for filling out the form. It was submitted with success.', :description => 'Form submission thank you message'
