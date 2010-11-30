function fitScreen(){
    var wh = $(window).height(),
        ch = $('#container').height();
    if (wh > ch) {
        $('#container').css('margin-top', ((wh - ch)/2) + 'px');
    }
}

$(document).ready(function(){
    fitScreen();
    $(window).resize(fitScreen);
});