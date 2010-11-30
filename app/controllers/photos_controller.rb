class PhotosController < ApplicationController
  before_filter :authenticate_user!, :except => :show
  include M::Resource
  layout 'admin'
  
  belongs_to :photo_gallery, :optional => true
  prepend_before_filter :massage_params, :only => :create
  before_update :set_crop_params

  def show
    referer = request.env['HTTP_REFERER']
    if referer.present? and referer =~ /jonreis|localhost/
      send_file File.join(Rails.root, 'assets', 'photos', params[:id], "#{params[:style]}.jpg"), 
                :type => 'image/jpeg', 
                :stream => false, 
                :disposition => 'inline', 
                :x_sendfile => false
    else
      render :file => File.join(Rails.root, 'public', '404.html')
    end
  end

  def create
    create! do |success, failure|
      success.html { render :json => {:url => @photo.file.url(:thumb), :id => @photo.id} }
      failure.html { render :json => @photo.errors }
    end
  end  
  
  def update
    update! do |success, failure|
      success.html { redirect_to params[:page_id] ? edit_admin_page_path(@page) : collection_path }
      failure.html { render :action => :edit }
    end
  end
  
  private
  
  resource_form do |f|
    f.input :file, :as => :file
  end
  
  def massage_params
    if params[:file].present?
      params[:photo] ||= {}
      params[:photo][:file] = params[:file] if params[:file].present?
      params[:photo][:file].content_type = MIME::Types.type_for(params[:photo][:file].original_filename).to_s
    end
  end
  
  def set_crop_params
    @photo.crop_x = params[:crop_left]
    @photo.crop_y = params[:crop_top]
    @photo.crop_w = params[:crop_width]
    @photo.crop_h = params[:crop_height]
  end
    
  def collection
    if params[:pages]
      @photos ||= Photo.all.paginate(:page => params[:page])
    else
      @photos ||= Photo.where(:page_id => nil).paginate(:page => params[:page])
    end
  end
  
end

