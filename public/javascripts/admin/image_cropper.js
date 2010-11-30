var ImageCropper = function(obj){
    var image = obj;
    var width = image.width();
    var height = image.height();
    
    var cropLeft = $('#crop_left');
    var cropTop  = $('#crop_top');
    var cropWidth= $('#crop_width');
    var cropHeight=$('#crop_height');
    var coords = null;

    var setCoords = function()
    {
        if (coords)
        {
            cropLeft.val(coords.x);
        	cropTop.val(coords.y);
        	cropWidth.val(coords.w);
        	cropHeight.val(coords.h);
        }
    }

    var setPreview = function(){
        if (coords)
        {
        	if (parseInt(coords.w) > 0)
        	{
        		var rx = 100 / coords.w;
        		var ry = 100 / coords.h;

        		jQuery('#preview').css({
        			width: Math.round(rx * image.width()) + 'px',
        			height: Math.round(ry * image.height()) + 'px',
        			marginLeft: '-' + Math.round(rx * coords.x) + 'px',
        			marginTop: '-' + Math.round(ry * coords.y) + 'px'
        		});
        	}
        }
    }

    var onImageCropperChange = function(c)
    {
        coords = c;
    	setPreview();
    	setCoords();
    };
    
    this.cropper = image.Jcrop({
        onChange: onImageCropperChange,
        onSelect: onImageCropperChange,
		aspectRatio: 1,
		setSelect: [ 0, 0, 200, 200 ],
		minSize: [200, 200]
    });
    
    
    
}

$(document).ready(function(){
    new ImageCropper($('#image_cropper img'));
});

// <input type="hidden" class="number" id="crop_left" name="crop_left" value="0" />
// <input type="hidden" class="number" id="crop_top" name="crop_top" value="0" />
// <input type="hidden" class="number" id="crop_width" name="crop_width" value="1" />
// <input type="hidden" class="number" id="crop_height" name="crop_height" value="1" />
// <input type="hidden" id="stencil_width" name="stencil_width" value="100" />
// <input type="hidden" id="stencil_height" name="stencil_height" value="100" />
// <input type="hidden" id="resize_to_stencil" name="resize_to_stencil" value="false" />
