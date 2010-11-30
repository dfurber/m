RuledTable = {
    init: function(element){
        jQuery(element).hoverIntent({
            interval: 50,
    		over: function(){
    		    jQuery(this).addClass("highlight");
    		},
    		out: function(){
    		    jQuery(this).removeClass("highlight");
    		}
        });
        
    }
}
