class BlogPostsController < ApplicationController
  include M::Resource
  actions :all, :except => [:show]
  layout 'admin'
  
  before_create :set_user

  private
  
  def set_user
    resource.user = current_user
  end

  paginate

  collection_table do |t|
    t.column :title, :header => 'Title'
    t.column :user_name, :header => 'Author'
    t.column :category_name, :header => 'Category'
    t.column :status_name, :header => 'Status'
  end
  default_order :title
  search_field :filter, :filter, :as => :string
  search_field :author, :author, :as => :select, :collection_helper => :blog_authors, :label => 'Author'
  search_field :category, :category, :as => :select, :collection_helper => :blog_categories, :label => 'Category'
  

  resource_form do |f|
    f.input :title
    f.input :slug, :input_html => {:class => 'slug'}
    f.input :draft_body, :label => 'Body'
    f.association :blog_category, :label => 'Category'
    f.input :status, :collection => [['Draft',0],['Published',1]]
  end
  
end