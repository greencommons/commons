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
    var daterange = $(this);
    var filtering = false;
    var start;
    var end;

    if (daterange.data('start') && daterange.data('end')) {
      filtering = true;
      start = moment.unix(daterange.data('start'));
      end = moment.unix(daterange.data('end'));
    } else {
      start = moment().subtract(7, 'days');
      end = moment()
    }

    daterange.daterangepicker({
      "startDate": start,
      "endDate": end,
      "buttonClasses": "btn btn-sm btn-gc",
      autoUpdateInput: false,
      locale: {
        format: 'MM/DD/YYYY',
        cancelLabel: 'Clear'
      }
    });

    if (filtering) {
      $(this).val(start.format('MM/DD/YYYY') + ' - ' + end.format('MM/DD/YYYY'));
    }

    daterange.on('apply.daterangepicker', function(ev, picker) {
      $(this).val(picker.startDate.format('MM/DD/YYYY') + ' - ' + picker.endDate.format('MM/DD/YYYY'));

      var url = new Uri(window.location.href);
      url.replaceQueryParam('filters[start]', picker.startDate.unix());
      url.replaceQueryParam('filters[end]', picker.endDate.unix());
      reload(url);
    });

    daterange.on('cancel.daterangepicker', function(ev, picker) {
      $(this).val('');

      var url = new Uri(window.location.href);
      url.deleteQueryParam('filters[start]');
      url.deleteQueryParam('filters[end]');
      reload(url);
    });
  });

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

