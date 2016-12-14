$(document).ready(function() {
  $("[data-autocomplete]").each(function() {
    var input = $(this);
    var path = input.data("autocomplete");

    input.on('input', function() {
      if(input.val().length > 0) {
        input.addClass("easy-autocomplete-loading");
      } else {
        input.removeClass("easy-autocomplete-loading");
      }
    });

    input.easyAutocomplete({
      url: function(query) {
        if (path.indexOf("?") >= 0) {
          return path + "&q=" + query;
        } else {
          return path + "?q=" + query;
        }
      },
      getValue: "email",
      list: {
        match: {
          enabled: true
        },
        onLoadEvent: function() {
          input.removeClass("easy-autocomplete-loading");
        }
      },
      requestDelay: 500,
      theme: "bootstrap"
    });
  });
});
