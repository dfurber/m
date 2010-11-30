class BlogCategoriesController < ApplicationController
  include M::Resource
  actions :all, :except => [:show]
  layout 'admin'
end