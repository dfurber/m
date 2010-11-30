class M::Resource::Initializer
  ACTIONS = [:read, :create, :update, :destroy]
  attr_accessor :name, :configuration, :resource_path, :resource_name, :resource_plural_name, :role_group
  def initialize(name, options={}, &block)
    @name, @configuration = name.to_sym, options
    @configuration[:actions] = ACTIONS
    @resource_name = name.to_s.underscore.gsub(/_/,' ').titleize
    @resource_path = name.to_s.underscore.downcase.pluralize
    @resource_plural_name = resource_name.pluralize

    block.call(self) if block_given?

    set_resource_path_namespace
    initialize_tab_options
    determine_role_group
    build_admin_tab
    build_permissions
  end
  
  def perms(*ary)
    ary = ary.pop if ary and ary.first.is_a?(Array)
    @configuration[:perms] ||= []
    @configuration[:perms] += ary
  end
  
  def namespace(path)
    @configuration[:namespace] = path
  end
  
  def skip_new
    @configuration[:actions] -= [:create]
  end
  
  def tab_only
    @configuration[:tab_only] = true
  end
  
  alias_method :skip_resource_permissions!, :tab_only
  
  class TabInitializer
    def initialize(parent, &block)
      @parent = parent
      block.call(self) if block_given?
    end
    def perm(perm)
      @parent.configuration[:tab][:perm] = perm
    end
    def group(name)
      @parent.configuration[:tab][:group] = name
    end
    def name(name)
      @parent.configuration[:tab][:name] = name
    end
  end
  
  def tab(&block)
    @configuration[:tab] = {}
    TabInitializer.new(self, &block)
  end
  
  def actions(*actions_to_keep)
    raise ArgumentError, 'Wrong number of arguments. You have to provide which actions you want to keep.' if actions_to_keep.empty?

    options = actions_to_keep.extract_options!
    actions_to_remove = Array(options[:except])
    actions_to_remove += ACTIONS - actions_to_keep.map { |a| a.to_sym } unless actions_to_keep.first == :all
    actions_to_remove.map! { |a| a.to_sym }.uniq!
    @configuration[:actions] = ACTIONS - actions_to_remove
  end
  
  
  private
  
  def set_resource_path_namespace
    if configuration[:namespace]
      @resource_path = "#{configuration[:namespace]}/#{resource_path}"
    end
  end
  
  def initialize_tab_options
    @configuration[:tab] ||= {}
    @configuration[:tab] = @configuration[:tab].reverse_merge :group => :content, :name => resource_plural_name, :path => resource_path, :perm => "access #{resource_plural_name.downcase}"
  end
  
  def determine_role_group
    @role_group = @configuration[:role_group] || case @configuration[:tab][:group]
      when :user then 'User Management'
      when :settings then 'Settings'
      when :content then 'Content'
    end
  end
  
  def build_admin_tab
    M.admin_tabs[@configuration[:tab][:group]][:items] << @configuration[:tab]
    if role_group == 'Content' and @configuration[:actions].include?(:create)
      M.admin_tabs[:content][:items].first[:items] << {:name => "New #{resource_plural_name.singularize.titleize}", :path => "#{resource_path}/new", :perm => "add new #{resource_path}"}
    end
  end
  
  def build_permissions
    if @configuration[:tab_only]
      M.permissions.add role_group, "access #{resource_plural_name.downcase}"
    else
      M.permissions.resource name, role_group, @configuration[:actions]
    end
    if @configuration[:perms]
      @configuration[:perms].each {|perm| M.permissions.add role_group, perm }
    end
  end
  
end

