//= require jquery_ujs
//= require_tree ./jquery
//= require functions
//= require todoist

$(function(){

  //Start page slider
  initSlider();

  //External links
  $("a[rel=external]").live("click", function(e) {
    $(this).attr({ target: "_blank" });
  });

  //Lazy load images
  initLazyLoading();

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

  //Episode hider
  initEpisodeHider();
  
  //Content carousel
  initContentCarousel();
  
  //Unwatched show links
  initUnwatchedAnchors();

  //Init Todoist.com tasks
  initTodoList();

  //Enable and disable the contact form
  initContactForm();

  //Init profile share
  initFacebookSend();
  
});