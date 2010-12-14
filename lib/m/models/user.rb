class User < ActiveRecord::Base

  devise :database_authenticatable, :lockable, 
         :recoverable, :rememberable, :trackable, :validatable,
         :encryptable, :encryptor => :strong_sha512#,
         #:authentication_keys => [:login, :email]
         

  attr_accessible :login, :password, :password_confirmation, :email, :first_name, :last_name, :survey_attributes, :language_ids, :tos, :remember_me
  
  validates_presence_of     :login, :email #, :first_name, :last_name
  validates_length_of       :login,    :within => 4..20
  validates_format_of       :first_name, :with => /^[\sA-Za-z0-9_-]+$/
  validates_presence_of     :first_name
  validates_length_of       :first_name, :within => 2..32
  validates_format_of       :last_name, :with => /^[\sA-Za-z0-9_-]+$/
  validates_presence_of     :last_name
  validates_length_of       :last_name, :within => 2..32
  validates_length_of       :email,    :within => 3..100
  validates_format_of       :email, :with => /^([^@\s]+)@((?:[-a-z0-9A-Z]+\.)+[a-zA-Z]{2,})$/
  validates_format_of       :login, :with => /^[\sA-Za-z0-9_-]+$/
  validates_uniqueness_of   :login, :case_sensitive => false, :if => Proc.new {|u| u.new_record? or u.login_changed? }
  validates_uniqueness_of   :email, :case_sensitive => false, :if => Proc.new {|u| u.new_record? or u.email_changed? }
    
  has_and_belongs_to_many :roles

  scope :administrators, lambda { includes(:roles).where('roles.name' => 'administrator')} #{:include => :roles, :conditions => {:role_id => 1}}

  scope :filter, lambda {|text| where({:login.matches => "%#{text}%"} | {:email.matches => "%#{text}%"})}
  scope :role_filter, lambda {|role_id| includes(:roles).where('roles_users.role_id' => role_id) if role_id && role_id.to_i > 0}

  def self.find_for_database_authentication(conditions)
    value = conditions[authentication_keys.first]
    where(["login = :value OR email = :value", { :value => value }]).first
  end

  def admin?
    @is_admin ||= roles.where(:name => 'administrator').any?
  end

  def password_required?
    new_record? or (not password.blank? and not password_confirmation.blank?)
  end

  def active?
    true
  end
  
  def permissions
    return @permissions if @permissions
    if new_record?
      perms = Role.where(:name => 'anonymous user').first.permissions
    else
      perms = (roles + [authenticated_user_role]).inject([]){|h,role| h += role.permissions}
      perms = perms.uniq
    end
    @permissions = {}
    perms.each{|perm| @permissions[perm] = true}
    @permissions
  end
  
  def can?(permission)
    (Key['site.admin.can'] && admin?) || permissions[permission]
  end
  
  def self.anonymous
    new :login => 'anonymous'
  end
  
  def self.ensure_administrator!
    options = M.config.admin
    options.symbolize_keys!
    admin = Role.where(:name => 'administrator').first.users
    return if admin.present?
    admin = User.find_or_initialize_by_login options[:login]
    if admin.new_record?
      admin.email = options[:email]
      admin.password = options[:password]
      admin.password_confirmation = options[:password]
      admin.first_name = options[:first_name]
      admin.last_name = options[:last_name]
    end
    admin.role_ids = Role.where(:name => 'administrator').map(&:id)
    admin.save!
  end
  
  def role_name
    roles.to_collection.map(&:name).sort.to_sentence
  end
  
  private
  
  def authenticated_user_role
    Role.find_by_name 'authenticated user'
  end
    
  
end
