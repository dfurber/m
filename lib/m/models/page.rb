class Page < Node
  
  # Web Form
  belongs_to :webform
  
  class << self
    
    def display_name
      'page'
    end

    def clear_cache
      Page.all.each {|page| page.touch }
      Rails.cache.delete "main_menu"
    end
    
    def home_page
      root
    end

    def missing?
      false
    end
    
    def ensure_root!
      if root.blank?
        page = create :title => 'Home Page', :slug => '', :menu_title => 'Home', :breadcrumb => 'Home', :url_alias => '', :root => true
        page.parts << PagePart.new(:name => 'Body', :content => 'Home page starter content.')
        page.save
      end
    end
  end
  
  def has_children?
    has_children
  end
  
  private
  
    
    def clean_url(url)
      "/#{ url.strip }/".gsub(%r{//+}, '/') 
    end
    
    def parent?
      !parent.nil?
    end
    
    def parse_object(object)
      text = show_draft ? object.draft_content : object.content
      text
    end
    

    
end
