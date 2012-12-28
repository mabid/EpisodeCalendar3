//= require jquery
//= require jquery_ujs
//= require_tree ./mobile

$(function(){
	$menu = null,
	$search = null;

	setOverlays();
	$(document).on("click", ".toggle-button", function(e) {
		$btn = $(this);
		var klass = "ui-btn-active-b";
		if ($btn.hasClass(klass))
			$btn.removeClass(klass);
		else {
			$(".toggle-button").removeClass(klass);
			$btn.addClass(klass);
		}
	});

	$(document).on("keyup", ".search input", function(){
		var $input = $(this);
		var value = $input.val();

		if (value == "")
			$input.removeClass("filled");
		else 
			$input.addClass("filled");
	});

	$(document).bind("pagebeforechange", hideOverlays).bind("pagechange", setOverlays);
});

var hideOverlays = function() {
	$menu.hide();
	$search.hide();
};

var setOverlays = function() {
	$menu = $(".ui-page-active .main-menu");
	$search = $(".ui-page-active .search");
};