# == Schema Information
# Schema version: 20090220171402
#
# Table name: snippets
#
#  id            :integer(4)      not null, primary key
#  name          :string(100)     default(""), not null
#  filter_id     :string(25)      
#  content       :text            
#  created_at    :datetime        
#  updated_at    :datetime        
#  created_by_id :integer(4)      
#  updated_by_id :integer(4)      
#  lock_version  :integer(4)      default(0)
#

# == Schema Information
# Schema version: 20090102151629
#
# Table name: snippets
#
#  id            :integer(4)      not null, primary key
#  name          :string(100)     default(""), not null
#  filter_id     :string(25)      
#  content       :text            
#  created_at    :datetime        
#  updated_at    :datetime        
#  created_by_id :integer(4)      
#  updated_by_id :integer(4)      
#  lock_version  :integer(4)      default(0)
#

class Snippet < ActiveRecord::Base
  
  # Default Order
  default_scope :order => 'name'
  
  # Associations
  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'

  # Validations
  validates_presence_of :name, :message => 'required'
  validates_length_of :name, :maximum => 100, :message => '%d-character limit'
  validates_format_of :name, :with => %r{^\S*$}, :message => 'cannot contain spaces or tabs'
  validates_uniqueness_of :name, :message => 'name already in use'
  
  before_save :scrub_erb
  after_update :expire_cache
  
  acts_as_activity :user, :if => Proc.new{|record| record.user } #don't record an activity if there's no user
  
  def expire_cache
    Rails.cache.delete self.name
  end
  
  def scrub_erb
    self.content.gsub!(/<%/,'&lt;%')
    self.content.gsub!(/%>/,'&gt;%')
  end

end
