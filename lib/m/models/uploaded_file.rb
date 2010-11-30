class UploadedFile < ActiveRecord::Base

  # field :file_file_name
  # field :file_file_size, :type => Integer
  # field :file_content_type

  validates_attachment_presence :file

end