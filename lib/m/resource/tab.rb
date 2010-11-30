class M::Resource::Tab
  include M::Resource::FormInputs
  attr_accessor :form, :resource_form_items, :css_id, :title, :partial
  
  def initialize(form, *args, &block)
    options = args.extract_options!
    options.symbolize_keys!
    @form, @css_id, @title, @partial = form, options[:css_id], options[:title], options[:partial]
    self.resource_form_items = []
    block.call(self) if block_given?
  end
  
  def append(&block)
    block.call(self) if block_given?    
  end
  
  def render(form)
    if partial.present?
      form.tab_from_partial(partial).html_safe
    else
      inputs(form)
    end
  end
  
    
end