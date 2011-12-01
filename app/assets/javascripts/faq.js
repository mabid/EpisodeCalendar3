$(document).ready(function() {
	$('#faq article ul').hide();
	
	$('#faq article#important h2 a').click(function(event) {
		event.preventDefault();
		$('a.active').removeClass('active');
		$('#faq article#important h2 a').addClass('active');
		$('#faq article#important ul').toggle();
		$('#faq article#position_hi ul').hide();
		$('#faq article#position_mid ul').hide();
		$('#faq article#position_lo ul').hide();
	});
	
	$('#faq article#position_hi h2 a').click(function(event) {
		event.preventDefault();
		$('a.active').removeClass('active');
		$('#faq article#position_hi h2 a').addClass('active');
		$('#faq article#position_hi ul').toggle();
		$('#faq article#important ul').hide();
		$('#faq article#position_mid ul').hide();
		$('#faq article#position_lo ul').hide();
	});
	$('#faq article#position_mid h2 a').click(function(event) {
		event.preventDefault();
		$('a.active').removeClass('active');
		$('#faq article#position_mid h2 a').addClass('active');
		$('#faq article#position_mid ul').toggle();
		$('#faq article#important ul').hide();
		$('#faq article#position_hi ul').hide();
		$('#faq article#position_lo ul').hide();
	});
	$('#faq article#position_lo h2 a').click(function(event) {
		event.preventDefault();
		$('a.active').removeClass('active');
		$('#faq article#position_lo h2 a').addClass('active');
		$('#faq article#position_lo ul').toggle();
		$('#faq article#important ul').hide();
		$('#faq article#position_hi ul').hide();
		$('#faq article#position_mid ul').hide();
	});
});