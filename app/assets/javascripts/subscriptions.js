//= require jquery/jquery-ui-1.8.16.custom.min

$(function(){

    $(window).load(check_form_filled());
    $('.radio_button').click( function() {
        var total_months = parseInt(this.value.split('-')[0]) + 1;
        var monthNames = [ "January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December" ];
        var today = new Date;
        var expirtion_date = new Date(today.getFullYear(), today.getMonth() + total_months, today.getDay());
        var plan_info = monthNames[expirtion_date.getMonth()] + ' ' + expirtion_date.getDate() + ' ' + expirtion_date.getFullYear();
        $('.plan_info').html(plan_info).slideDown('slow');
        check_form_filled();
    });

    $('input[type=text]').bind('click blur', function() {
        check_form_filled();
    });

    $("table").delegate('td,th','mouseover mouseleave', function(e) {
        if (e.type == 'mouseover') {
            var index = $(this).index();
            $("td."+index).addClass("hover");
        }
        else {
            var index = $(this).index();
            $("td."+index).removeClass("hover");
        }
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