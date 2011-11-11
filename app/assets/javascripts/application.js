//= require jquery_ujs
//= require_tree ./jquery
//= require functions

$(document).ready(function(){

  //External links
  $("a[rel=external]").attr({ target: "_blank" });

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
  
  //Settings tabs
  initTabs();
  
  //Facebook like
  initFacebookLike();

  //Reflection
  initBannerReflection();
  
  //Toggle episode overview
  initEpisodeOverviewToggle();
  
  //Content carousel
  initContentCarousel();
  
  //Unwatched show links
  initUnwatchedAnchors();
  
  //Init buyable products
  initProductAds();

});