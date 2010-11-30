jQuery(document).ready(function($) {
	var onMouseOutOpacity = 0.67;
	$('#thumbs ul.thumbs li').opacityrollover({
		mouseOutOpacity:   onMouseOutOpacity,
		mouseOverOpacity:  1.0,
		fadeSpeed:         'fast',
		exemptionSelector: '.selected'
	});
	
	// Initialize Advanced Galleriffic Gallery
	var gallery = $('#thumbs').galleriffic({
		delay:                     5000,
		numThumbs:                 25,
		preloadAhead:              10,
		enableTopPager:            true,
		enableBottomPager:         true,
		maxPagesToShow:            7,
		imageContainerSel:         '#slideshow',
		controlsContainerSel:      '#controls',
        // captionContainerSel:       '#caption',
		loadingContainerSel:       '#loading',
		renderSSControls:          true,
		renderNavControls:         true,
		playLinkText:              'Slideshow On',
		pauseLinkText:             'Slideshow Off',
		prevLinkText:              '<img src="/images/theme/gallery-prev.gif" />',
		nextLinkText:              '<img src="/images/theme/gallery-next.gif" />',
		nextPageLinkText:          '<img src="/images/theme/gallery-next.gif" />',
		prevPageLinkText:          '<img src="/images/theme/gallery-prev.gif" />',
		enableHistory:             false,
		autoStart:                 true,
		syncTransitions:           true,
		defaultTransitionDuration: 500,
        onSlideChange:             function(prevIndex, nextIndex) {
        						       // 'this' refers to the gallery, which is an extension of $('#thumbs')
        						       this.find('ul.thumbs').children()
        							    .eq(prevIndex).fadeTo('fast', onMouseOutOpacity).end()
        							    .eq(nextIndex).fadeTo('fast', 1.0);
        					        },
        onPageTransitionOut:       function(callback) {
        						        this.fadeTo('fast', 0.0, callback);
        					        },
        onPageTransitionIn:        function() {
        						        this.fadeTo('fast', 1.0);
        					        }    
    });
});
