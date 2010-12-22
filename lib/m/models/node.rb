class Node < ActiveRecord::Base

  # Validations
  validates_presence_of :title, :breadcrumb, :status_id, :message => 'required'  
  validates_presence_of :slug, :if => Proc.new {|p| p.ancestry.present?}
  validates_length_of :title, :maximum => 255, :message => '%d-character limit'
  validates_length_of :slug, :maximum => 100, :message => '%d-character limit'
  #validates_length_of :breadcrumb, :maximum => 160, :message => '%d-character limit'
  validates_format_of :slug, :with => %r{^([-_.A-Za-z0-9]*|/)$}, :message => 'invalid format'  
  validates_uniqueness_of :slug, :scope => :ancestry, :message => 'slug already in use for child of parent'
  
  has_one :node_content, :dependent => :destroy
  accepts_nested_attributes_for :node_content
  
  belongs_to :snippet
  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'
  
  acts_as_activity :user
    
  @@status = {
    'draft' => 1,
    'published' => 2,
    1 => 'draft',
    2 => 'published',
    :draft => 1,
    :published => 2
  }
  cattr_accessor :status
  attr_accessor :save_and_publish, :unpublish, :show_draft, :order, :trash
  
  # Callbacks
  after_initialize :set_status
  
  before_save :rebuild_path
  before_save :update_published_at
  
  after_update  :expire
  after_destroy :expire

  # Core Associations
  has_ancestry
  acts_as_list :scope => :siblings
  scope :nodes_on_site_map, lambda { where :show_on_site_map => true }
  
  #default_scope :order => :position
  scope :filter, lambda {|text| where({:title.matches => "%#{text}%"})}

  def traverse
    subtree.where(:show_on_site_map => true).arrange(:order => :position)
  end

  # Override acts_as_list bottom_item so that it works with ancestry tree not having a scope column like parent_id
  def bottom_item(except = nil)
    except ? siblings.reject{|page| page == self }.last : siblings.last
  end
  
  def skip_top_level_page?
    skip_top_level_page == true and has_children?
  end
  
  def self.statuses
    [["Draft", 1], ["Published", 2]]
  end
  
  def self.sidebar_menu_options
    [["No menu on sidebar", 0], ["Show pages underneath this page on site map", 1], ["Show pages at the same level as this page in the site map", 2]]
  end
  
  def user
    updated_by_id.present? ? updated_by : created_by
  end
  
  def user_id
    updated_by_id || created_by_id
  end
  
  def expire
    url = (url_alias || '').chomp("/")
    url = "/home" if url.blank?
    Rails.cache.delete "views#{url}"
    Rails.cache.delete "views#{url}.html"
    true
  end
  
  def self.root
    Node.where(:is_root => true).first
  end
  
  def self.display_name
    'content'
  end
  
  def name; title; end
  
  def body_for_editing
    return @body_for_editing if @body_for_editing
    self.node_content = NodeContent.new if node_content.blank?
    node_content.draft_content  
  end
  
  def body_for_editing=(value)
    if node_content.blank?
      self.node_content = NodeContent.new 
    end
    self.node_content.draft_content = value
  end
  
  def menu_children
    children.where(:show_on_site_map => true)
  end
  
  def public_children(*args)
    if args and user=args.first and user.can?('access pages')
      return children
    end
    menu_children.where(:show_on_menu => true, :status_id => @@status[:published])
  end

  def public_siblings(*args)
    pages = siblings.where(:show_on_menu => true, :show_on_site_map => true).order(:position)
    if args and user=args.first and user.can?('access pages')
      return pages
    end
    pages.where(:show_on_site_map => true, :show_on_menu => true, :status_id => @@status[:published])
  end
  
  def status
    @@status[self.status_id]
  end
  def status=(value)
    self.status_id = value
  end
  
  def url
    url_alias
  end
  
  def draft_url
    "#{url_alias}?draft=true"
  end
  
  def description
    self["description"]
  end
  
  def description=(value)
    self["description"] = value
  end
  
  def title_for_menu
    menu_title.present? ? menu_title : title
  end
  
  def published?
    status == 'published'
  end
  
  def draft?
    status == 'draft'
  end
  
  def home?
    ancestry.blank? && is_root
  end
  
  
  private
  
  def set_status
    self.status_id ||= @@status['draft']
    true
  end

  def rebuild_path
    self.parent = Node.root if show_on_site_map and ancestors.blank? and !node.is_root
    self.url_alias = (self.ancestors.collect(&:slug).join('/') || '') + '/' + (slug || '')
    true
  end
  
  def update_published_at
    if self.status_id == @@status['published']
      self.node_content.content = node_content.draft_content
      self.published_at = Time.now
    end
    # if unpublish
    #   self.published_at = nil
    #   self.status_id = @@status['draft']
    # elsif self.save_and_publish
    #   self.status_id = @@status['published']
    #   self.published_at = Time.now
    #   parts.each {|part| part.update_attributes :content => part.draft_content}
    # end
    true
  end
  
end
