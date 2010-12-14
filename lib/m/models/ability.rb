class Ability
  cattr_accessor :permission_blocks
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.anonymous
    load_permissions_for_user(user)
    alias_action :remove, :to => :destroy
    check_additional_permissions(user)
    can :manage, :all if user.admin? && Key['site.admin.can']
    can :manage, M::Permissions::Permission if user.can?('access permissions')
    can :read, Photo # until check_additional_permissions actually works...
    can :read, Node do |resource|
      resource.published? || can?(:update, resource)
    end
    can :toggle, Page do
      check 'show/hide page on site menu'
    end
    can :sitemap, Page do
      check 'edit sitemap'
    end
    resources registry
  end
  
  def check_additional_permissions(user)
    if @@permission_blocks
      @@permission_blocks.each do |block|
        block.call(user)
      end
    end
  end
  
  def self.permissions(&block)
    @@permission_blocks ||= []
    @@permission_blocks << block
  end
  
  # Resources are added to the registry during the init process. It is simply an array of class name symbols
  # for every resource that was initialized using the resource initializer. (The M.configure block - see 
  # init_resources.rb for example.)
  def registry
    ::M.permissions.registry
  end
  
  def self.register(resource_name)
    raise ArgumentError unless resource_name.is_a?(Symbol)
    registry << resource_name
  end
  
  private
  
  def load_permissions_for_user(user)
    @perms = user.permissions
  end
  
  def check(rule)
    @perms[rule]
  end
  
  # Shorthand way to pass in several resources at once. Such as:
  # resources :User, :Page, :Node
  def resources(*args)
    args = args.first if args.is_a?(Array)
    args.each do |arg|
      resource(arg) if arg.present?
    end
  end
  
  # Defines 'can' rules for standard resource actions. If the permission isn't present because, fx, the resource
  # only allows edit, then create will always return false because there would be no 'add new' permission for it.
  # Example:
  # resource :Photo
  def resource(model_name)
    name = model_name.to_s.underscore.downcase.gsub(/_/,' ').pluralize
    resource_name = model_name.to_s.constantize
    can :read,    resource_name do check "access #{name}"; end
    can :create,  resource_name do check "add new #{name}"; end
    can :update,  resource_name do check "edit #{name}"; end
    can :destroy, resource_name do check "delete #{name}"; end  
  end
  
end