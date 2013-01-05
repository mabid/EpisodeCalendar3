//= require jquery/jquery-ui-1.8.16.custom.min

$(function(){

    $(window).load(check_form_filled());
    $('.radio_button').click( function() {
        $("#plan_info span").hide();
        $("#expiration_date_" + $(this).closest("td").index()).show();
        check_form_filled();
    });

    $('input[type=text]').bind('click blur', function() {
        check_form_filled();
    });

    function check_form_filled(){
        $('.form_entries').each(function(index,Element){
            var disabled = false;
            if($('.radio_button').val() == ''){
                disabled = true;
            }
            if(Element.value == '') {
                disabled = true;
            }
            if(disabled){
                $('.submit').attr('disabled', 'disabled');
            } else {
                $('.submit').removeAttr('disabled');
            }
        });
    }

});