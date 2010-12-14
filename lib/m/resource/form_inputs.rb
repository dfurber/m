module M::Resource::FormInputs
  
  include M::Helpers::CollectionHelper
  extend ActiveSupport::Concern
  included do

    def inputs(form)
      if resource_form_items.blank?
        if form.object.respond_to?(:name)
          form.send :input, :name
        elsif form.object.respond_to?(:title)
          form.send :input, :title
        end
      else
        resource_form_items.map {|input| 
          if form.object.respond_to?(input[:method])
            if only_action = input.delete(:only)
              next if only_action == :edit and form.object.new_record?
              next if only_action == :new  and form.object.persisted?
            end
            form.send(input[:type], input[:method], input[:options]).html_safe 
          end
        }.join("\n").html_safe
      end
    end

    def input(method, *args)
      options = args.extract_options!
      if options[:as] and options[:as] == :select
        options[:collection] = collection_from_resource_form_helper(options)
      end
      self.resource_form_items << {:type => :input, :method => method, :options => options}
    end

    def association(method, *args)
      options = args.extract_options!
      # options[:collection] = collection_from_resource_form_helper(options)
      self.resource_form_items << {:type => :association, :method => method, :options => options}
    end

    def collection_radios(method, *args)
      options = args.extract_options!
      # options[:collection] = collection_from_resource_form_helper(options)
      self.resource_form_items << {:type => :collection_radios, :method => method, :options => options}
    end

    def collection_check_boxes(method, *args)
      options = args.extract_options!
      # options[:collection] = collection_from_resource_form_helper(options)
      self.resource_form_items << {:type => :collection_check_boxes, :method => method, :options => options}
    end
    
    def has_file_input
      resource_form_items.select {|item| item[:options][:as] == :file}.size > 0
    end
    
  end
  
  
end