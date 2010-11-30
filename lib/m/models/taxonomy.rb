class Taxonomy < ActiveRecord::Base
  has_ancestry
  belongs_to :tagging, :polymorphic => true
end
