class Admin::SnippetsController < Admin::BaseController

  adminify  
  
  resource_form do |f|
    f.input :name
    f.input :content
  end
  
end