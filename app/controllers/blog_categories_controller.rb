class BlogCategoriesController < ApplicationController
  resourcify
  actions :all, :except => [:show]
  layout 'admin'
end