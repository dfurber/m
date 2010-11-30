class NodeContent < ActiveRecord::Base
  
  # Associations
  belongs_to :node
  
  # Validations
  validates_numericality_of :id, :node_id, :allow_nil => true, :only_integer => true, :message => 'must be a number'
  
  after_initialize :initialize_content
  before_save :scrub_erb
  
  def initialize_content
    self.content ||= ""
    self.draft_content ||= ""
  end
  
  def scrub_erb
    self.content.gsub!(/<%/,'&lt;%')
    self.content.gsub!(/%>/,'&gt;%')
  end

end
