class WebformMailer < ActionMailer::Base
  
  def admin_notification(form)
    setup_recipients(form.webform)
    from               submitter_of(form)
    subject            form.webform.name
    @form_data = form.attributes
  end
  
  def response(form)
    from               submitter_of(form)
    subject            (form.webform.email_subject || form.webform.name)
    @email_template = form.webform.email_template
    if form.webform.document_id.present?
      attachments[form.webform.document.file_file_name] = File.read form.webform.document.file.path
    end
  end
  
  private
  
  def setup_recipients(webform)    
    if webform.send_to_email.present?
      recipients webform.send_to_email
      return
    end
    users = User.administrators.all
    if users.blank?
      recipients "David Furber <dfurber@gorges.us>"
    else
      recipients users.map {|user| "#{user.login} <#{user.email}>"}.join(", ")
    end
  end
  
  def submitter_of(form)
    "#{form.name} <#{form.email}>"
  end
end
