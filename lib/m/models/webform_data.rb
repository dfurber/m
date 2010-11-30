class WebformData
  attr_accessor :webform, :attributes

  include ActiveModel::Validations
  
  def initialize(attributes = {}, webform)
    @attributes, @webform = attributes, webform
  end

  def read_attribute_for_validation(key)
    @attributes[key]
  end
  
  def to_key
    []
  end
  
  def save
    if valid?
      WebformMailer.admin_notification(self).deliver
      if webform.send_to_email
        WebformMailer.response(self).deliver
      end
    else
      false
    end
  end
  
end