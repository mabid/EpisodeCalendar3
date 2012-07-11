//= require jquery_ujs
//= require_tree ./jquery
//= require functions
//= require todoist

$(document).ready(function(){

  //Start page slider
  initSlider();

  //External links
  $("a[rel=external]").live("click", function(e) {
    $(this).attr({ target: "_blank" });
  });

  //Hide flashes
  hideFlashes();
  
	//Hijack Ajax forms
	$(".ajaxForm").submitWithAjax();
	
	//Hijack Ajax links
	hijackAjaxLinks();
		
	//Nice checkboxes
  $("input").checkBox();
  
  //Ajax checkboxes
  initAjaxCheckbox();
	
	//Hint the search input
	$("#q").hint();
	
	//Init tooltip
	initTooltip();
	
	//Table sorter
  initTableSorter();
  
  //Togglers init
  initTogglers();
  
  //Checkbox toggler
  initCheckboxTogglers();
  
  //Seen Progress
  renderProgress();
  
  //Facebook like
  initFacebookLike();

  //Reflection
  initBannerReflection();
  
  //Toggle episode overview
  initEpisodeOverviewToggle();

  //Toggle episode overview
  initEpisodeHider();
  
  //Content carousel
  initContentCarousel();
  
  //Unwatched show links
  initUnwatchedAnchors();
  
  //Init buyable products
  //initProductAds();

  //Init Todoist.com tasks
  initTodoList();

  //Enable and disable the contact form
  initContactForm();

  //Init profile share
  initFacebookSend();

});