var CKconfig = {
	toolbar:
	[
		['Source', '-', 'Bold', 'Italic', '-', 'NumberedList', 'BulletedList', '-', 'Link', 'Unlink', '-', 'Image', 'Flash'],
		['UIColor']
	]
};

PageForm = {
    tabs: {
        'page-body' : function(){
          $( 'div.input.text textarea' ).ckeditor(CKconfig);  
        },
        'page-meta': function(){
            jQuery('.title').each(function(){
                var slug = jQuery('.slug'); //,
                    //breadcrumb = jQuery('.breadcrumb')
                oldTitle = this.value;

                if (!slug) return;

                jQuery(this).everyTime(150, function(){
                    if (oldTitle.toSlug() == slug.val()) slug.val(this.value.toSlug());
                    //if (oldTitle == breadcrumb.val()) breadcrumb.val(this.value);
                    oldTitle = this.value;
                });

            });
        }
    }
}

jQuery(document).ready(function(){

    $('form.snippet').each(function(){
        $( 'div.input.text textarea' ).ckeditor(CKconfig);
    })
    
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

