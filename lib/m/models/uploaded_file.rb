class UploadedFile < ActiveRecord::Base

  # field :file_file_name
  # field :file_file_size, :type => Integer
  # field :file_content_type

  validates_attachment_presence :file

  attr_accessor :user

  acts_as_activity :user, :if => Proc.new{|record| record.user } #don't record an activity if there's no user

  def user_id
    user ? user.id : nil
  end

end