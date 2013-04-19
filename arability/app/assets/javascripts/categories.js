$(function() {
  $(".categories-autocomplete").typeahead({
    source: get_categories
    })
})

function get_categories(query, callback) {
  return ["test"]
}
