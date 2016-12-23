$(document).on('ready turbolinks:load', function () {
  $("[data-expand]").each(function() {
    var button = $(this);
    var hideButton = $(button.data('reverse'));
    var target = $(button.data('expand'));

    button.on('click', function(e) {
      e.preventDefault();
      button.toggle();
      hideButton.toggle();
      target.slideToggle();
    });
  });
});
