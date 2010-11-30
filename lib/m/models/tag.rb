class Tag < Taxonomy
  belongs_to :taggable, :polymorphic => true
end