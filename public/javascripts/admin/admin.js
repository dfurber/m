PageForm = {
    tabs: {
        'page-meta': function(){
            jQuery('.title').each(function(){
                var slug = jQuery('.slug'),
                    breadcrumb = jQuery('.breadcrumb')
                oldTitle = this.value;

                if (!slug || !breadcrumb) return;

                jQuery(this).everyTime(150, function(){
                    if (oldTitle.toSlug() == slug.val()) slug.val(this.value.toSlug());
                    if (oldTitle == breadcrumb.val()) breadcrumb.val(this.value);
                    oldTitle = this.value;
                });

            });
        },
        'page-photos': function(){
            if (typeof PhotoUploader == 'undefined') return;
            if ($('#thumbnails').size() > 0){
                $('#thumbnails').sortable({
                  items: "li",
                  appendTo: 'body',
                  connectWith: '#trash',
                  dropOnEmpty: true,
                  update: sortUpdate
                });
                $('#thumbnails').disableSelection();
                $('#trash').sortable({
                    connectWith: '#thumbnails',
                    dropOnEmpty: true
                });
                $('#crop').droppable({
                    connectWith: '#thumbnails',
                    dropOnEmpty: true,
                    drop: function(ev, ui){
                        var action = $('form').attr('action');
                        var id = $(ui.draggable).attr('id').replace('photo_','');
                        document.location = action + "/photos/" + id + "/edit";
                        return false;
                    }
                });
            }
            PhotoUploader.init();
            PhotoUploader.uploader.refresh();
            
        }
    }
}

jQuery(document).ready(function(){

    jQuery('table.index').each(function(){
        if (this.id == "site_map") {
            SiteMap.init(this);
        } else {
            RuledTable.init(this);
        }
    });

    jQuery('#tab-control').each(function(){
        TabControl.init(this);
        $('div.pages div.page').each(function(){
            var body = $(this).attr('id').replace('page', 'tab');
            TabControl.addTab(body, $(this).attr('data-tabname'), $(this).attr('id'));
        })
        TabControl.autoSelect();
        
    });
    
});

calculatePositions = function(){
    var ids = [], trashes = [];
    $('#thumbnails li').each(function(){
      ids.push(this.id.replace("photo_",""));
    });
    $("#page_order").val(ids.join(","));
    if ($('#page_order').val() == "") {
        $('#page_order').val('empty')
    }
    $('#trash li').each(function(){
        trashes.push(this.id.replace("photo_",""));
    });
    $("#page_trash").val(trashes.join(","));
    return true;
}


String.prototype.upcase = function() {
    return this.toUpperCase();
}

String.prototype.downcase = function() {
    return this.toLowerCase();
}
  
String.prototype.toInteger = function() {
    return parseInt(this);
}

String.prototype.strip = function(){
    return this.replace(/^\s+/, '').replace(/\s+$/, '')
}

String.prototype.toSlug = function() {
    return this.strip().toLowerCase().replace(/[^-a-z0-9~\s\.:;+=_]/g, '').replace(/[\s\.:;=+]+/g, '-');
}

keys = function(obj) {
    var keys = [];
    for (var property in obj)
        keys.push(property);
    return keys;
}

first = function(obj){
    return obj[0];
}

last = function(obj) {
  return obj[obj.length - 1];
}

var sortUpdate = function(){
    calculatePositions();
    var data = {
        authenticity_token: upload_tokens.authenticity_token,
        _method: 'put',
        'page[order]': $('#page_order').val(),
        'page[trash]': $('#page_trash').val()
    }
    var action = $('form').attr('action');
    $.post(action, data, function(){
        $('#trash').html('');
        $('#page_trash').val('');
    });
}
