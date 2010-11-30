class Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.anonymous
    load_permissions_for_user(user)
    alias_action :remove, :to => :destroy
    can :manage, :all if user.admin? && Key['site.admin.can']
    can :manage, M::Permissions::Permission if user.can?('access permissions')
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
  
  def registry
    ::M.permissions.registry
  end
  
  def self.register(resource_name)
    # TODO: ensure this is a symbol
    registry << resource_name
  end
  
  private
  
  def load_permissions_for_user(user)
    @perms = user.permissions
  end
  
  def check(rule)
    @perms[rule]
  end
  
  def resources(*args)
    args = args.first if args.is_a?(Array)
    args.each do |arg|
      resource(arg) if arg.present?
    end
  end
  
  def resource(model_name)
    name = model_name.to_s.underscore.downcase.gsub(/_/,' ').pluralize
    resource_name = model_name.to_s.constantize
    can :read,    resource_name do check "access #{name}"; end
    can :create,  resource_name do check "add new #{name}"; end
    can :update,  resource_name do check "edit #{name}"; end
    can :destroy, resource_name do check "delete #{name}"; end  
  end
  
end