//= require jquery
//= require jquery_ujs
//= require_tree ./mobile

$(function() {

	var $document = $(document);

	$document.on("click", ".toggle-button", function(e) {
		$btn = $(this);
		var klass = "ui-btn-active-b";
		if ($btn.hasClass(klass))
			$btn.removeClass(klass);
		else {
			$(".toggle-button").removeClass(klass);
			$btn.addClass(klass);
		}
	});

	$document.on("keyup", ".search input", function(){
		var $input = $(this);
		var value = $input.val();

		if (value == "")
			$input.removeClass("filled");
		else 
			$input.addClass("filled");
	});

	$document.on("touchmove", ".ui-popup-screen, .ui-popup-container", function(e) {
		if (!$(e.target).hasClass("overview"))
			return false;
	});

	$document.on("click", "li .mark", function(e) {
		e.preventDefault();
		var $link = $(this);
		if ($link.hasClass("loading"))
			return;
		var marked = !!$link.data("marked") ? 0 : 1;
		var episode_id = $link.closest("li").data("episode-id");
		
		var $icon = $link.find(".ui-icon");
		$link.addClass("loading");
		mark_episode(marked, $link, $icon);
	});

	$document.bind("pageinit", function() {
		$("#header").appendTo("body");
	});

	$document.bind("pageload", function(){
		$("#header .toggle-button").removeClass("ui-btn-active-b");
	});
});

var mark_episode = function(marked, $link, $icon) {
	var url = $link.attr("href") + ($link.attr("href").indexOf("?") > 0 ? "&" : "?") + "mark=" + marked;
    
    //Send ajax request
    $.ajax({
      type: "POST",
      url: url,
      dataType: "script",
      data: {},
      success: function() {
      	$link.removeClass("loading");
		if (marked) {
			$icon.removeClass("ui-icon-check-off").addClass("ui-icon-check");
		}
		else {
			$icon.removeClass("ui-icon-check").addClass("ui-icon-check-off");
		}
		$link.data("marked", marked);
      }
    });
};