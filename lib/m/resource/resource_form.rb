module M
  module Resource
    class Form
      include M::Resource::FormInputs
      attr_accessor :resource_form_items, :tabs #, :resource_form_tabs, :css_id, :title, :partial
      def initialize(&block)
        @resource_form_items, @tabs = [], {}
        block.call(self) if block_given?
      end
      def append(&block)
        block.call(self) if block_given?    
      end
      def render(form)  #:nodoc:
        inputs(form)
      end
      
      def tab(css_id, title, *args, &block)  #:nodoc:
        options = args.extract_options!
        options.symbolize_keys!
        options[:css_id] = css_id
        options[:title]  = title
        if tabs.key?(css_id) and not options.delete(:replace)
          tabs[css_id].append(&block)
        else
          self.tabs[css_id] = M::Resource::Tab.new(self, options, &block)
        end
      end
      
      def has_file_input_with_tabs  #:nodoc:
        return true if has_file_input_without_tabs
        tabs.each do |k, tab|
          return true if tab.has_file_input
        end
        return false
      end
      alias_method_chain :has_file_input, :tabs
      
    end
  end
end

module M::Resource::ResourceForm

  extend ActiveSupport::Concern
  included do

    private
    
    def resource_form_has_tabs?  #:nodoc:
      self.class.resource_form_object.present? && self.class.resource_form_object.tabs.present?
    end
    
    def resource_form_tabs(form)  #:nodoc:
      if resource_form_has_tabs?
        form.send(:tabs, self.class.resource_form_object.tabs)
      end
    end
    
    def resource_form_has_file_input?  #:nodoc:
      self.class.resource_form_object.present? && self.class.resource_form_object.has_file_input
    end
    
    def resource_form_inputs(form)  #:nodoc:
      self.class.resource_form_object.render(form)
    end
    

    class << self
      def resource_form(&block)
        if resource_form_object.blank?
          self.resource_form_object = M::Resource::Form.new(&block)
        else
          self.resource_form_object.append(&block)
        end
      end
      def tab(css_id, title, *args, &block)
        self.resource_form_object ||= M::Resource::Form.new
        resource_form_object.tab(css_id, title, *args, &block)
      end
    end
    
  end


end