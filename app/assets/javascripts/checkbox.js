$(document).on('ready turbolinks:load', function () {
  $("[data-indeterminate-checkbox]").each(function() {
    var checkbox = $(this);

    if (checkbox.data('indeterminate-checkbox')) {
      var list = checkbox.parents('li').children('ul');
      var children = list.find('input[type="checkbox"]');

      checkbox.change(function(e) {
        children.prop('checked', checkbox.is(':checked'));
      });

      children.change(function(e) {
        if (list.find('input[type="checkbox"]:checked').length > 0) {
          checkbox.prop('checked', true);
        } else {
          checkbox.prop('checked', false);
        }
      });
    }
  });
});
