# Override of collection input to accommodate custom collection options.
module SimpleForm
  module Inputs
    class CollectionInput
      include M::Helpers::CollectionHelper
      def input
        collection = (collection_from_resource_form_helper(options) || self.class.boolean_collection).to_a
        detect_collection_methods(collection, options)
        @builder.send(:"collection_#{input_type}", attribute_name, collection, options[:value_method],
                      options[:label_method], input_options, input_html_options)
      end
    end
  end
end

class SimpleForm::FormBuilder
  
  include M::Helpers::CollectionHelper
    
  def collection_radios(attribute, options={}, html_options={})
    label = label(attribute, options[:label] || attribute.to_s.titleize)
    hint = options[:hint] ? '' : @template.content_tag(:span, options[:hint], :class => 'hint')
    options[:collection] = collection_from_resource_form_helper(options)
    collection = options[:collection]
    text_method = options[:text]
    value_method = options[:value]
    
    radios = collection.map do |item|
      value = item.send value_method
      text  = item.send text_method

      default_html_options = default_html_options_for_collection(item, value, options, html_options)

      @template.content_tag(:div, radio_button(attribute, value, default_html_options) <<
        label("#{attribute}_#{value}", text, :class => "collection_radio"))
    end.join.html_safe
    
    @template.content_tag(:div, label + radios + hint, :class => 'input collection_radio')
  end

  def collection_checkboxes(attribute, options={}, html_options={})
    label = label(attribute, options[:label] || attribute.to_s.titleize)
    hint = options[:hint] ? '' : @template.content_tag(:span, options[:hint], :class => 'hint')
    options[:collection] = collection_from_resource_form_helper(options)
    collection = options[:collection]
    text_method = options[:text]
    value_method = options[:value]

    check_boxes = collection_check_boxes(attribute, collection, value_method, label_method, options, html_options)
    @template.content_tag(:div, label + check_boxes + hint, :class => 'input collection_check_boxes')
  end

  def collection_check_boxes(attribute, collection, value_method, text_method, options={}, html_options={})
    collection.map do |item|
      value = item.send value_method
      text  = item.send text_method

      default_html_options = default_html_options_for_collection(item, value, options, html_options)
      default_html_options[:multiple] = true

      @template.content_tag(:div, 
      check_box(attribute, default_html_options, value, '') <<
        label("#{attribute}_#{value}", text, :class => "collection_check_boxes"))
    end.join.html_safe
  end

  def association(association, options={}, &block)
    return simple_fields_for(*[association, options[:collection], options].compact, &block) if block_given?
    raise ArgumentError, "Association cannot be used in forms not associated with an object" unless @object

    options[:as] ||= :select
    @reflection = find_association_reflection(association)
    raise "Association #{association.inspect} not found" unless @reflection
    case @reflection.macro
    when :belongs_to, :referenced_in, :references_one
      attribute = @reflection.options[:foreign_key] || :"#{@reflection.name}_id"
    when :has_one
      raise ":has_one association are not supported by f.association"
    else
      attribute = "#{@reflection.name.to_s.singularize}_ids".to_sym

      if options[:as] == :select
        html_options = options[:input_html] ||= {}
        html_options[:size]   ||= 5
        html_options[:multiple] = true unless html_options.key?(:multiple)
      end
    end
    options[:collection] = collection_from_resource_form_helper(options)
    options[:collection] ||= @reflection.klass.all(@reflection.options.slice(:conditions, :order))
    input(attribute, options).tap { @reflection = nil }
  end

  def tabs(form_tabs)
    unless form_tabs.empty?
      tab_control = @template.content_tag(:div, '', :id => 'tabs', :class => 'tabs').html_safe
      pages = @template.content_tag(:div, form_tabs.map do |k, tab|
        deferred_content = @template.content_tag(:script, tab.render(self), :type => 'text/html')
        @template.content_tag(:div, deferred_content, :id => "page-#{tab.css_id}", :class => 'page', 'data-tabname' => tab.title)
      end.join("\n").html_safe, :class => 'pages', :id => 'pages')
      @template.content_tag(:div, tab_control + pages, :id => 'tab-control').html_safe
    end
  end
    
  def tab_from_partial(partial)
    @template.render(:partial => partial, :locals => {:form => self})
  end 
  
end