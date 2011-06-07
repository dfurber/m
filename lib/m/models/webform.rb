class Webform < ActiveRecord::Base

  belongs_to :document

  before_validation :scrub_attributes
  
  def self.ensure!(*args)
    options = args.extract_options!
    options.symbolize_keys!
    webform = Webform.find_or_initialize_by_template options[:template]
    if webform.new_record?
      webform.name = options[:name]
      webform.save!
    end
  end
  
  def scrub_attributes
    ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
    attributes.each do |k,v|
      write_attribute k, ic.iconv(v)
    end
  end
  
end
