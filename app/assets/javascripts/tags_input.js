$(document).on('ready turbolinks:load', function () {
  $('[data-gctagsinput]').each(function() {
    var container = $(this);
    var input = container.children('input');

    input.tagsinput({
      itemText: function(item) {
        return item;
      }
    });

    var child = container.children('.bootstrap-tagsinput').children('input');

    input.on('itemAdded', function(event) {
      child.attr('placeholder', '');
      child.css('width', '6em');
    });

    input.on('itemRemoved', function(event) {
      if(input.tagsinput('items').length == 0) {
        child.attr('placeholder', 'Separate tags with commas...');
      }
    });
  });
});
