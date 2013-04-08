$(document).ready(function() {

	$("div.alert").removeClass("row");

	$('a[data-toggle="tab"]').on('click', function(e) {
		history.pushState(null, null, $(this).attr('href'));
	});

	window.addEventListener("popstate", function(e) {
		var activeTab = $('[href=' + location.hash + ']');
		if (activeTab.length) {
			activeTab.tab('show');
		} else {
			$('.nav-tabs a:first').tab('show');
		}
	});
	
});