//= require active_admin/base
//= require jquery/jquery-ui-1.8.16.custom.min

var fixHelper = function(e, ui) {
    ui.children().each(function() {
        $(this).width($(this).width());
    });
    return ui;
};

$(function(){

  $("#faqs tbody").sortable({
    axis: 'y',
    handle: '.drag_handle',
    helper: fixHelper,
    update: function(){
      $.ajax({
        url: "/faqs/sort",
        type: "post",
        beforeSend: function(xhr) {
          xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
        },
        data: $(this).sortable('serialize')
      });
      $("#faqs tr:odd").removeClass("even");
      $("#faqs tr:even").addClass("even");
    }
  });

});