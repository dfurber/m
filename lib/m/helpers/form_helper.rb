module ActionView::Helpers::FormHelper

  include M::Helpers::CollectionHelper

  # Overrides the default form builder so that if options[:url] isn't already set, it checks for existence
  # of inherited resources url helpers and uses them. The reason is that those helpers are wonderfully smart about 
  # detecting customs path or namespace whereas the default form_for is not. Makes it easier for inherited_resources
  # views to have a swiss army knife utility for handling admin resources, non-admin resources, nested resources,
  # and so on.
  # Inherited resources helpers are only used if you do not use options[:url] or pass in an array, such as [:admin, resource]
  # (although the purpose of this modification is to keep you from having to do that unless you are posting
  # to a different resource, and from having to fuss with the array in case you have optional nesting in your
  # resource, such as posting to @photo or [@user, @photo] depending on context).
  def apply_form_for_options!(object_or_array, options) #:nodoc:
    object = object_or_array.is_a?(Array) ? object_or_array.last : object_or_array
    object = convert_to_model(object)

    html_options =
      if object.respond_to?(:persisted?) && object.persisted?
        { :class  => options[:as] ? "#{options[:as]}_edit" : dom_class(object, :edit),
          :id => options[:as] ? "#{options[:as]}_edit" : dom_id(object, :edit),
          :method => :put }
      else
        { :class  => options[:as] ? "#{options[:as]}_new" : dom_class(object, :new),
          :id => options[:as] ? "#{options[:as]}_new" : dom_id(object),
          :method => :post }
      end

    options[:html] ||= {}
    options[:html].reverse_merge!(html_options)
    if options[:url].blank?
      if respond_to?(:collection_path) and form_object_is_not_an_array?(object_or_array)
        options[:url] = object.new_record? ? collection_path : resource_path(object)
      else
        options[:url] ||= options[:format] ? \
          polymorphic_path(object_or_array, :format => options.delete(:format)) : \
          polymorphic_path(object_or_array)
      end
    end
  end
  
  def form_object_is_not_an_array?(object_or_array)
    object_or_array.is_a?(Array) ? (object_or_array.size <= 1) : true
  end
  
  
end