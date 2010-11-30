class Admin::SnippetsController < Admin::BaseController

  paginate
  
  resource_form do |f|
    f.input :name
    f.input :content
  end
  
end