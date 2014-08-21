var Initializer = {
  dialog_closer: function() {
    $('.js-dialog-closer').click(function() {
      var dialog = $('#' + $(this).data('dialog-closer'));
      $.closeModal(dialog);
    });
  },
  custom_select: function() {
    $('select:visible').customSelect().change(function() {
      var select = $(this);
      if (select.val() == '') {
        select.next().removeClass('valuable');
      }
      else {
        select.next().addClass('valuable');
      }
    });
  }
};

$(document).ready(function() {
  for (var method in Initializer) {
    Initializer[method].call();
  }
});
