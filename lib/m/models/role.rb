class Role < ActiveRecord::Base
  
  # field :name, :type => String
  # field :permissions, :type => String
  # field :locked, :type => Boolean
  
  has_and_belongs_to_many :users
  
  attr_protected :locked
  validates_uniqueness_of :name
  validates_presence_of :name
  
  default_scope :order => 'name'
  scope :to_collection, lambda {
    order(:name).where("name not in ('authenticated user', 'anonymous user')")
  }
  
  def permissions
    return @permission_list if @permission_list
    @permission_list = (read_attribute('permissions') || '').split('|')
  end
  
  def can?(permission)
    (name == 'administrator' && Key['site.admin.can']) || permissions.include?(permission.name)
  end
  
  def update_permissions(list)
    update_attributes :permissions => list.join('|')
  end
  
  def first
    id
  end
  
  def last
    name
  end
  
  def self.ensure!(*args)
    options = args.extract_options!
    options.symbolize_keys!
    role = Role.find_or_initialize_by_name options[:name]
    role.locked = true
    role.save!
  end
  
  
    
end
