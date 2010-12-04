if defined? ActionDispatch::Http::UploadedFile
  ActionDispatch::Http::UploadedFile.send(:include, Paperclip::Upfile)
end

module Paperclip
  class << self
    def logger #:nodoc:
      Rails.logger
    end
  end
end