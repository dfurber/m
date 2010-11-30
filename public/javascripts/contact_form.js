$(document).ready(function(){
    $('#inquiry_types > dl.own_line > dd > input').click(function(){
        switch ($(this).attr('id')) {
            case "contact_inquiry_type_aerial_photography":
                hidePortraitIfOpen();
                hideEventDateIfOpen();
                showAerialIfClosed();
                break;
            case "contact_inquiry_type_business_portrait":
                hideAerialIfOpen();
                hideEventDateIfOpen();
                showPortraitIfClosed();
                break;
            case "contact_inquiry_type_event":
                hideAerialIfOpen();
                hidePortraitIfOpen();
                showEventDateIfClosed();
                break;
            default:
                hideAerialIfOpen();
                hidePortraitIfOpen();
                hideEventDateIfOpen();
        }
    });
    $('#contact_inquiry_type_aerial_photography:checked').each(function(){
        $('#aerial_types').show();
    });
    $('#contact_inquiry_type_business_portrait:checked').each(function(){
        $('#portrait_types').show();
    });
    $('#contact_inquiry_type_event:checked').each(function(){
        $('#event_date').show();
    });
});

var hideAerialIfOpen = function(){
    var elm = $('#aerial_types')
    if (elm.is(':visible'))
        elm.slideUp();
}

var hidePortraitIfOpen = function(){
    var elm = $('#portrait_types')
    if (elm.is(':visible'))
        elm.slideUp();
}

var hideEventDateIfOpen = function(){
    var elm = $('#event_date')
    if (elm.is(':visible'))
        elm.slideUp();
}

var showAerialIfClosed = function(){
    var elm = $('#aerial_types')
    if (elm.is(':hidden'))
        elm.slideDown();
}

var showPortraitIfClosed = function(){
    var elm = $('#portrait_types')
    if (elm.is(':hidden'))
        elm.slideDown();
}

var showEventDateIfClosed = function(){
    var elm = $('#event_date')
    if (elm.is(':hidden'))
        elm.slideDown();
}
