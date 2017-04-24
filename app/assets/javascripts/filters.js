var initFilters = function() {
  $('input[name="daterange"]').daterangepicker({
    "startDate": moment().subtract(7, 'days'),
    "endDate": moment(),
    "buttonClasses": "btn btn-sm btn-gc",
    locale: {
      format: 'DD/MM/YYYY'
    }
  }, function(start, end, label) {
    // Handle filtering
  });

  $('[data-filter-select]').each(function() {
    var select = $(this);

    select.on('change', function(e) {
      var url = new Uri(window.location.href)
      url.replaceQueryParam('sort', select.val())

      $('#search-loader__panel').show()
      window.history.pushState({}, "", url);
      $.ajax({
        url: url,
        type: 'GET',
        dataType: 'script'
      })
    });
  });

  $('[data-filter-checkbox]').each(function() {
    var checkbox = $(this);

    checkbox.on('change', function(e) {
      var url = new Uri(window.location.href)

      $('[data-filter-checkbox]').each(function() {
        var check = $(this);
        if (check.is(":checked") == true) {
          url.replaceQueryParam(check.attr('name'), 'on')
        } else {
          url.deleteQueryParam(check.attr('name'))
        }
      });

      $('#search-loader__panel').show()
      window.history.pushState({}, "", url);
      $.ajax({
        url: url,
        type: 'GET',
        dataType: 'script'
      })
    });
  });
};

$(document).on('ready turbolinks:load', function () {
  initFilters();
});
