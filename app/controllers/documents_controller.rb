class DocumentsController < ApplicationController
  def show
    document = Document.where(:file_file_name => "#{params[:filename]}.#{params[:ext]}").first
    document.increment_downloads
    
    send_file document.file.path, 
              :content_type => document.file_content_type,
              :stream => false, 
              :disposition => 'inline', 
              :x_sendfile => false
  end
  
end