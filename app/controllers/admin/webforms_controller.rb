class Admin::WebformsController < Admin::BaseController
  actions :index, :edit, :update
  
  collection_table do |t|
    t.row_actions :edit
  end
  
  tab :meta, 'Meta' do |f|
    f.input :name
    f.input :show_name, :as => :boolean, :label => 'Show this as title of the form when displayed to the user.'
    f.input :instructions
    f.input :thanks_path, :label => 'Thanks URL', :hint => 'Where to take the user after they submit the form. Leave blank to return to the page with the form. Format: /contact'
    f.input :thanks_message, :label => 'Thanks Msg', :hint => 'If you leave the \'Thanks URL\', would you like to show a special thank you message after the user submits the form?'
  end
  
  tab :email, 'Email Response' do |f|
    f.input :send_to_email, :hint => 'info@domain.com, me@nowhere.com'
    f.association :document, :label => 'Attachment', :hint => 'Selected file will be sent to the person who fills out the form via auto responder.'
    f.input :email_subject, :hint => 'If blank, defaults to the name of the form.'
    f.input :email_template, :as => :text, :hint => 'Template for response to user who filled out the form. Leave blank to send no response.'
  end
  
  
end

