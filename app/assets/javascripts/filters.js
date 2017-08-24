var initFilters = function() {
  var reload = function(url) {
    $('#ajax-loader__panel').show();
    window.history.pushState({}, "", url);
    $.ajax({
      url: url,
      type: 'GET',
      dataType: 'script'
    });
  };

  $('input[name="daterange"]').each(function() {
    var daterange = $(this)
    var start = daterange.data('start') ? moment.unix(daterange.data('start')) : moment().subtract(7, 'days')
    var end = daterange.data('end') ? moment.unix(daterange.data('end')) : moment()

    daterange.daterangepicker({
      "startDate": start,
      "endDate": end,
      "buttonClasses": "btn btn-sm btn-gc",
      locale: {
        format: 'MM/DD/YYYY'
      }
    }, function(start, end, label) {
      var url = new Uri(window.location.href);
      url.replaceQueryParam('filters[start]', start.unix());
      url.replaceQueryParam('filters[end]', end.unix());
      reload(url);
    });
  })

  $('[data-filter-select]').each(function() {
    var select = $(this);

    select.on('change', function(e) {
      var url = new Uri(window.location.href);
      url.replaceQueryParam('sort', select.val());
      reload(url);
    });
  });

  $('[data-filter-checkbox]').each(function() {
    var checkbox = $(this);

    checkbox.on('change', function(e) {
      var url = new Uri(window.location.href);

      var parent = checkbox.parents('li').parents('li')
                           .children('.filters__item').find('input');
      var list = checkbox.parents('li').children('ul');
      var children = list.find('input[type="checkbox"]');

      if (checkbox.data('indeterminate-checkbox')) {
        children.prop('checked', checkbox.is(':checked'));
      } else if (checkbox.data('indeterminate-checkbox-child')) {
        if (list.find('input[type="checkbox"]:checked').length > 0) {
          parent.prop('checked', true);
        } else {
          parent.prop('checked', false);
        }
      }

      $('[data-filter-checkbox]').each(function() {
        var check = $(this);
        if (check.is(":checked") === true) {
          url.replaceQueryParam(check.attr('name'), 'on');
        } else {
          url.deleteQueryParam(check.attr('name'));
        }
      });

      reload(url);
    });
  });
};

$(document).on('ready turbolinks:load', function () {
  initFilters();
});
