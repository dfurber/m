class Webform < ActiveRecord::Base

  belongs_to :document
  
  def self.ensure!(*args)
    options = args.extract_options!
    options.symbolize_keys!
    webform = Webform.find_or_initialize_by_template options[:template]
    if webform.new_record?
      webform.name = options[:name]
      webform.save!
    end
  end
end
