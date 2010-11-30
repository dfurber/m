$(document).ready(function(){
    $('#slideshow img').each(function() {
        $(this).css({marginLeft: 290 - $(this).width()/2});
    });
    $('#slideshow').cycle({
        fx: "fade",
        next: "#slideshow",
        pager: "#slideshow_pager",
        after: function(){
            $('#caption').html(this.alt)
        },
        pagerAnchorBuilder: function(i,el){
            return "<a href=\"#\"><img src=\"" + $(el).attr("src").replace(/large/,'thumb') + "\" /></a>";
        }
    });
    // $('#slideshow_pager').jcarousel({
    //     vertical:true,
    //     scroll: 10
    // })
})