class WebformData < ActiveRecord::Base 
  
  attr_accessor :webform

  def self.columns
    @columns ||= [];
  end

  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default,
      sql_type.to_s, null)
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