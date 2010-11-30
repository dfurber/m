var PhotoUploader = {};

PhotoUploader.init = function(){
    $('#tab-photos').click(function(){
        PhotoUploader.uploader.refresh();
    });
    PhotoUploader.uploader = new plupload.Uploader({
         runtimes : 'html5,silverlight,flash',
         url        : upload_url,
         max_file_size : '10mb',
         //chunk_size : '1mb',
         unique_names : true,
         browse_button : 'pickfiles',
         container : 'plupload_container',
         multipart: true,
         multipart_params: upload_tokens,
         filters : [
             {title : "Image files", extensions : "bmp,jpg,gif,png"},
         ],
         flash_swf_url : '/swf/plupload.flash.swf',
         silverlight_xap_url : '/javascripts/plupload/plupload.silverlight.xap'
     })
    PhotoUploader.uploader.bind('Init', function(){ window.setTimeout('PhotoUploader.uploader.refresh();', 100) }) ;
 	PhotoUploader.uploader.init();

 	PhotoUploader.uploader.bind('FilesAdded', function(up, files) {
 		$.each(files, function(i, file) {
 			$('#filelist').append(
 				'<div id="' + file.id + '" class="uploadifyQueueItem">' +
 				file.name + ' (' + plupload.formatSize(file.size) + ') <strong></strong>' +
 				'<div class="uploadifyProgress"><div class="uploadifyProgressBar" style="width:0%"></div></div>' +
 			'</div>');
 		});
 		up.refresh(); // Reposition Flash/Silverlight
 		up.start();
 	});

 	PhotoUploader.uploader.bind('UploadProgress', function(up, file) {
 	    $('#' + file.id + " div.uploadifyProgressBar").css('width', file.percent + '%');
 		$('#' + file.id + " strong").html(file.percent + "%");
 	});

 	PhotoUploader.uploader.bind('Error', function(up, err) {
 		$('#filelist').append("<div>Error: " + err.code +
 			", Message: " + err.message +
 			(err.file ? ", File: " + err.file.name : "") +
 			"</div>"
 		);

 		up.refresh(); // Reposition Flash/Silverlight
 	});
 	PhotoUploader.uploader.bind('FileUploaded', PhotoUploader.onComplete);
 	
}

PhotoUploader.onComplete = function(up, file, resp){
    $('#' + file.id).remove();
    var response = resp.response;
    var json = $.parseJSON(response);
    $('#thumbnails').append("<li id='photo_" + json.id + "'><img src=\"" + json.url + "\" /></li>")
    $('#thumbnails').sortable('refresh');
    up.refresh();
}

