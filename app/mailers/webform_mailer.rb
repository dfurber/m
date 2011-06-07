class WebformMailer < ActionMailer::Base
  
  def admin_notification(form)
    setup_recipients(form.webform)
    from               submitter_of(form)
    subject            form.webform.name
    @form_data = form.attributes
  end
  
  def response(form)
    @email_template = form.webform.email_template
    if form.webform.document_id.present? and File.exists?(form.webform.document.file.path)
      attachments[form.webform.document.file_file_name] = File.read form.webform.document.file.path
    end
    mail :from  => Key['webform.from'],
         :subject => (form.webform.email_subject || form.webform.name),
         :to => submitter_of(form)
  end
  
  private
  
  def setup_recipients(webform)    
    unless webform.send_to_email.blank?
      recipients webform.send_to_email
      return
    end
    users = User.administrators.all
    if users.blank?
      recipients Key['webform.from']
    else
      recipients users.map {|user| "#{user.login} <#{user.email}>"}.join(", ")
    end
  end
  
  def submitter_of(form)
    "#{form.name} <#{form.email}>"
  end
end
