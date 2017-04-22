$(document).on('ready turbolinks:load', function () {
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
});
