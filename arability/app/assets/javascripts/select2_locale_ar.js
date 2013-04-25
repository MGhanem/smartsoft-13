/**
 * Select2 Arabic translation.
 *
 * Author: Mohamed Ashraf <mohamed.ashraf.213@gmail.com>
 */
(function ($) {
    "use strict";

    $.extend($.fn.select2.defaults, {
        formatNoMatches: function () { return "لا توجد نتائج"; },
        formatInputTooShort: function (input, min) {
          var n = min - input.length;
          return "Please enter " + n + " more character" + (n == 1 ? "" : "s");
        },
        formatInputTooLong: function (input, max) {
          var n = input.length - max;
          return "Please enter " + n + " less character" + (n == 1? "" : "s");
        },
        formatSelectionTooBig: function (limit) {
          return "You can only select " + limit + " item" + (limit == 1 ? "" : "s");
        },
        formatLoadMore: function (pageNumber) { return "Loading more results..."; },
        formatSearching: function () { return "Searching..."; },
        formatResult: function (result, container, query, escapeMarkup) {
            return escapeMarkup(result.text);
        }
    });
})(jQuery);
