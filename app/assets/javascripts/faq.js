var fixHelper = function(e, ui) {
    ui.children().each(function() {
        $(this).width($(this).width());
    });
    return ui;
};

$(function(){

  $("#faqs tbody").sortable({
    axis: 'y',
    handle: '.handle',
    helper: fixHelper,
    update: function(){
      $.post($(this).data('update-url'), $(this).sortable('serialize')); 
    }
  });

});