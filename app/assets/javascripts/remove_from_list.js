var initRemovers = function() {
  $('[data-sc-remove]').each(function() {
    var link = $(this);

    link.on('click', function(e) {
      e.preventDefault();
      $('#ajax-loader__panel').show();

      $.ajax({
        url: link.data('sc-remove'),
        type: 'DELETE',
        dataType: 'script'
      });
    });
  });
};

$(document).on('ready turbolinks:load', function () {
  initRemovers();
});
